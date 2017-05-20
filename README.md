# Cart APP

使用 Rails 實作簡易購物車系統

## 安裝一些有用的 Gems

```ruby
# Gemfils.rb
.
.
gem 'simple_form'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'font-awesome-sass', '~> 4.7.0'
gem "slim-rails"

group :development, :test do
  .
  .
  gem 'pry-rails'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'annotate'
end
```

## 撰寫 RSpec

### 購物車功能

**基本功能**

- 可以把商品加進購物車
- 可以計算出購物車的商品有幾種
  - 例如 A、B 商品被加進購物車，所以購物車總共有 2 種商品
- 可以計算每個商品在購物車的個別數量
  - 例如 A 商品被加進了 5 次，所以有 5 個；B 商品被加進了 3 次，所以有 3 個
- 加進購物車的商品不會是其他東西
  - 例如 A 商品被加進購物車，它仍然是 A 商品，若 A 商品被取出也還是個 A 商品，不會是 B 商品
- 可以計算每個商品的小計金額
  - 例如 A 商品單價 100 元，被加進了 5 次，所以小計是 100 x 5 = 500
- 可以計算整個購物車商品的總額
  - 例如 A 商品小計是 500 元，B 商品小計是 300 元，所以購物車總額是 500 + 300 = 800

**進階功能**

- 在特定的時間，會有滿千折百的優惠價格
  - 例如在 6 月時，總額滿 1000，可以折抵 100，所以 1000 - 100 = 900
- 在特定的節日，會有 9 折的優惠價格 
  - 例如在聖誕節，總額 1000，可以打 9 折，所以 1000 * 0.9 = 900

### 安裝 Rspec

```shell
$ rails g rspec:install
```

### Cart model 測試

產生一個 `Cart` model 的 rspec：

```shell
$ rails g rspec:model Cart
```

實作購物車的方法，是使用 Session 把購物車存起來，不會真的把資料寫進資料庫，因此 `Cart` model 是一個 PORO（Plain Old Ruby Object），就是一個純類別物件，所以要手動新增 `app/modles/cart.rb`：

```ruby
class Cart
end
```

在 `spec/models/cart_spec.rb` 加上：

```ruby
require 'rails_helper'

RSpec.describe Cart, type: :model do

  describe "Basic feature" do

    it "can add to cart"
    it "can calculate every item's quantity"
    it "will be a Product"
    it "can calculate every item's subtotal price"
    it "can calculate cart's total price"
    it "has a discount of NT$ 100 for a NT$ 1,000"
    it "has a discount of 10% on Christmas day"

  end
end
```

#### test 1: can add to cart

**可以把東西加進購物車**

```ruby
# spec/models/cart_spec.rb

it "can add to cart" do
  cart = Cart.new

  cart.add_item 1

  expect(cart.empty?).to be false
  # or, 帶有 ? 的 method 都可以寫成 be_XXXXX
  # expect(cart.empty?).not_to be_empty
end
```

預期出現錯誤，因為目前沒有實作 `Cart.new`，也沒有 `add_item` 和 `empty` method。

在 `app/models/cart.rb` 加上：

```ruby
class Cart

  def initialize
    @items = []
  end

  def add_item(id)
    @items << id
  end

  def empty?
    @items.empty?
  end
end
```

實體化購物車的時候，設定它是一個陣列，每次執行 `cart.add_item 1` ，就會把東西加（push）進去：

```ruby
cart = Cart.new   # => []

cart.add_item(1)  # => [1]
cart.add_item(1)  # => [1,1]
cart.add_item(2)  # => [1,1,2]
```

一台購物車，裡面會有很多項目：

```ruby
Cart -> [item1, item2, item3]
```

這邊只是先簡單測試能不能把東西加進去，之後會再繼續實作購物車項目的 class。

在 `empty?` method，因為 `@items` 是個陣列，所以可以使用陣列 method 來做判斷裡面是不是空的。

整理一下程式碼，使用 `attr_reader`，方便外部讀取 `@items`：

```ruby
class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(id)
    items << id
  end

  def empty?
    items.empty?
  end
end
```

#### test 2: can calculate every item's quantity

**可以計算商品的數量**

```ruby
# spec/models/cart_spec.rb

.
.
it "can calculate every item's quantity" do
  cart = Cart.new

  2.times { cart.add_item(1) }
  3.times { cart.add_item(2) }
  4.times { cart.add_item(1) }

  expect(cart.items.length).to be 2
  expect(cart.items.first.quantity).to be 6
  expect(cart.items.last.quantity).to be 3
end
```

當把商品加進購物車的時候，可以做一個判斷，如果 `add_item(id)` 傳進的 `id` 已經在購物車中存在，那就增加那個 `id` 商品的數量；如果不存在這個 `id` 就產生一個新的商品項目，然後把這個新的商品加進購物車。

```ruby
# app/models/cart.rb

class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(id)
    found_item  = items.find { |item| item.product_id == id }

    if found_item
      found_item.increment
    else
      items << CartItem.new(id)
    end
  end
  .
  .
end
```

這時候還是會有錯誤，因為沒有 `CartItem` 這個 class。

建立一個 `CartItem` model：

```ruby
# app/models/cart_item.rb

class CartItem
  attr_reader :product_id, :quantity

  def initialize(product_id, quantity = 1)
    @product_id = product_id
    @quantity = quantity
  end

  def incremant(n = 1)
    @quantity += n
  end
end
```

整理一下，一台購物車，裡面會有很多不同的商品項目，每個商品項目會有自己的 `product_id` 和 `quantity`。

在建立一個新的商品項目時，預設接收兩個參數，一個是 `product_id`，一個是 `quantity`，而 `quantity` 預設值為 `1`，也就是說，當商品項目被加進購物車時，數量預設都是 1。

```ruby
Cart.new # => 一台購物車
CartItem.new(id) # => 一個商品項目，接收一個 id 參數，quantity 預設為 1，所以不用特別傳進去

cart = Cart.new
product1 = CartItem.new(1)
product2 = CartItem.new(2) 
```

`increment` method 的 `n` 參數也是預設為 `1`，預設一次加一個。其中：

```ruby
@quantity += n

# 如果寫成這樣，會 error
quantity += n # => quantity = quantity + n

# 因為其實 quantity += n 是這樣
quantity = quantity + n

# 第二個 quantity 變成 local variable，會抓不到值
```

#### test 3: will be a Product

**加進購物車的會是個 A，從購物車取出來時也是 A，不會是 B**

```ruby
# spec/models/cart_spec.rb

.
.
it "will be a Product" do
  p1 = Product.create(name: "P1")
  p2 = Product.create(name: "P2")
  cart = Cart.new

  2.times { cart.add_item(p1.id) }
  3.times { cart.add_item(p2.id) }

  expect(cart.items.first.product).to be_kind_of Product
  expect(cart.items.last.product_id).to be p2.id
end
```

因為要測試實際的商品，所以需要先建立兩個商品出來，預期出現錯誤，因為還沒有 `Product` model。

產生一個 `Product` model：

```shell
$ rails g model Product name price:integer
$ rails db:migrate
```

預期還是會出現錯誤，因為沒有 `product` method：

```ruby
cart.items.first.product # 預期找出在商品項目裡的第一個商品的 id
```

所以在 `CartItem` 做一個 `product` method：

```ruby
# app/models/cart_item.rb

class CartItem
  attr_reader :product_id, :quantity

  .
  .
  def product
    Product.find_by(id: product_id)
  end
end
```

#### test 4: can calculate every item's subtotal price

**可以計算商品項目的個別小計金額**

因為這個測試跟商品項目有關，所以可以在 `spec/models/cart_item_spec.rb` 寫測試：

```ruby
# spec/models/cart_item_spec.rb

describe "Basic feature" do
  it "can calculate every item's subtotal price" do
    p1 = Product.create(name: "P1", price: 100)
    p2 = Product.create(name: "P2", price: 200)
    cart = Cart.new

    2.times { cart.add_item(p1.id) }
    3.times { cart.add_item(p2.id) }

    expect(cart.items.first.subtotal_price).to be 200
    expect(cart.items.last.subtotal_price).to be 600
  end
end
```

預期出現錯誤，因為沒有 `subtotal_price` method。

在 `app/models/cart_item.rb` 加上：

```ruby
# app/models/cart_item.rb

class CartItem
  attr_reader :product_id, :quantity

  .
  .
  def product
    Product.find_by(id: product_id)
  end

  def subtotal_price
    product.price * quantity
  end
end
```

#### test 5: can calculate cart's total price

**可以計算購物車所有的商品的總額**

這個測試是跟購物車相關，所以又回到 `spec/models/cart_spec.rb`。

```ruby
# spec/models/cart_spec.rb

.
.
it "can calculate cart's total price" do
  p1 = Product.create(name: "P1", price: 100)
  p2 = Product.create(name: "P2", price: 200)
  cart = Cart.new

  2.times { cart.add_item(p1.id) }
  3.times { cart.add_item(p2.id) }

  expect(cart.total_price).to be 800
end
```

預期出現錯誤，因為沒有 `total_price` method。

```ruby
# app/models/cart.rb

class Cart
  attr_reader :items

  .
  .
  def total_price
    total = items.reduce(0) { |total, item| total + item.subtotal_price }
  end
end
```

#### test 6: has a discount of NT$ 100 for a NT$ 1,000

**在特定的時間，會有滿千折百的優惠價格**

```ruby
# spec/models/cart_spec.rb

.
.
it "can calculate cart's total price" do
  p1 = Product.create(name: "P1", price: 100)
  p2 = Product.create(name: "P2", price: 200)
  cart = Cart.new

  4.times { cart.add_item(p1.id) }
  5.times { cart.add_item(p2.id) }

  t = Time.local(2017, 6, 18, 12, 0)
  Timecop.travel(t) {
    expect(cart.total_price).to be (1400 - 100)
  }
end
```

可以使用 Timecop gem 來設定特定的時間。

在 `app/models/cart.rb` 加上判斷：

```ruby
# app/models/cart.rb

class Cart
  attr_reader :items

  .
  .
  def total_price
    total = items.reduce(0) { |total, item| total + item.subtotal_price }

    if Time.now.month == 6 && total >= 1000
      total -= 100
    else
      total
    end
  end
end
```

#### test 7: has a discount of 10% on Christmas day

**在特定的節日，會有 9 折的優惠價格**

```ruby
# spec/models/cart_spec.rb

.
.
it "has a discount of 10% on Christmas day" do
  p1 = Product.create(name: "P1", price: 100)
  p2 = Product.create(name: "P2", price: 200)
  cart = Cart.new

  4.times { cart.add_item(p1.id) }
  5.times { cart.add_item(p2.id) }

  t = Time.local(2017, 12, 25, 0, 0)
  Timecop.travel(t) {
    expect(cart.total_price).to be 1260
  }
end
```

可以使用 Timecop gem 來設定特定的時間。

在 `app/models/cart.rb` 加上判斷：

```ruby
# app/models/cart.rb

class Cart
  attr_reader :items

  .
  .
  def total_price
    total = items.reduce(0) { |total, item| total + item.subtotal_price }

    if Time.now.month == 6 && total >= 1000
      total -= 100
    elsif Time.now.month == 12 && Time.now.day == 25
      total = (total * 0.9).round
    else
      total
    end
  end
end
```

## 重構程式碼

### 使用 let 重構

測試程式碼中有很多重複的程式碼，例如：

```ruby
cart = Cart.new

p1 = Product.create(name: "P1", price: 100)
p2 = Product.create(name: "P2", price: 200)
```

可以利用 `let`：

```ruby
let(:cart) { Cart.new }
let(:p1) { Product.create(name: "P1", price: 100) }
let(:p2) { Product.create(name: "P2", price: 200) }
```

### 使用 FactoryGirl 重構

在 `spec/factories/products.rb` 設定假資料：

```ruby
actoryGirl.define do
  factory :product do
    # 如果沒有加 {} 會做出一樣的結果
    # title Faker::Commerce.product_name
    # price Faker::Number.between(50, 100)
    name { Faker::Commerce.product_name }
    price { Faker::Number.between(50, 100) }

    trait :price_100 do
      price 100
    end

    trait :price_200 do
      price 200
    end
  end
end
```

透過 Faker gem 可以做出亂數資料。

`trait` 可以根據測試設定想要的條件，例如上述各設定了兩種價錢。
