order1  = Order.create(amount: 1000)
order2  = Order.create(amount: 2000)
order3  = Order.create(amount: 3000)
order4  = Order.create(amount: 4000)
order5  = Order.create(amount: 5000)
order6  = Order.create(amount: 6000)
order7  = Order.create(amount: 7000)
order8  = Order.create(amount: 8000)
order9  = Order.create(amount: 9000)
order10 = Order.create(amount: 10000)
order11 = Order.create(amount: 11000)
order12 = Order.create(amount: 12000)
order13 = Order.create(amount: 13000)
order14 = Order.create(amount: 14000)
order15 = Order.create(amount: 15000)
order16 = Order.create(amount: 16000)
order17 = Order.create(amount: 17000)
order18 = Order.create(amount: 18000)
order19 = Order.create(amount: 19000.49)
order20 = Order.create(amount: 20000.50)
order21 = Order.create(amount: 1000)
order22 = Order.create(amount: 2000)
order23 = Order.create(amount: 3000)
order24 = Order.create(amount: 4000)
order25 = Order.create(amount: 5000)
order26 = Order.create(amount: 6000)
order27 = Order.create(amount: 7000)
order28 = Order.create(amount: 8000)
order29 = Order.create(amount: 9000)
order30 = Order.create(amount: 10000)
order31 = Order.create(amount: 11000)
order32 = Order.create(amount: 12000)
order33 = Order.create(amount: 13000)
order34 = Order.create(amount: 14000)
order35 = Order.create(amount: 15000)
order36 = Order.create(amount: 16000)
order37 = Order.create(amount: 17000)
order38 = Order.create(amount: 18000)
order39 = Order.create(amount: 19000.11)
order40 = Order.create(amount: 20000.22)

max_id = Order.maximum(:id)
Order.find_each { |ord| ord.update(created_at: ord.created_at - (86400 * 13 * (max_id - ord.id))) }
