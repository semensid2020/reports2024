# Generate Users
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.update(
  password: 'password',
  password_confirmation: 'password',
)

user1 = User.find_or_initialize_by(email: 'user1@example.com')
user1.update(
  password: 'password',
  password_confirmation: 'password',
)

user2 = User.find_or_initialize_by(email: 'user2@example.com')
user2.update(
  password: 'password',
  password_confirmation: 'password',
)

order1  = Order.create(amount: 1000,  user: user1)
order2  = Order.create(amount: 2000,  user: user1)
order3  = Order.create(amount: 3000,  user: user1)
order4  = Order.create(amount: 4000,  user: user1)
order5  = Order.create(amount: 5000,  user: user1)
order6  = Order.create(amount: 6000,  user: user2)
order7  = Order.create(amount: 7000,  user: user2)
order8  = Order.create(amount: 8000,  user: user2)
order9  = Order.create(amount: 9000,  user: user2)
order10 = Order.create(amount: 10000, user: user2)
order11 = Order.create(amount: 11000, user: user2)
order12 = Order.create(amount: 12000, user: user1)
order13 = Order.create(amount: 13000, user: user1)
order14 = Order.create(amount: 14000, user: user2)
order15 = Order.create(amount: 15000, user: user2)
order16 = Order.create(amount: 16000, user: user2)
order17 = Order.create(amount: 17000, user: user1)
order18 = Order.create(amount: 18000, user: user2)
order19 = Order.create(amount: 19000.49, user: user1)
order20 = Order.create(amount: 20000.50, user: user2)
order21 = Order.create(amount: 1000, user: user2)
order22 = Order.create(amount: 2000, user: user2)
order23 = Order.create(amount: 3000, user: user2)
order24 = Order.create(amount: 4000, user: user2)
order25 = Order.create(amount: 5000, user: user2)
order26 = Order.create(amount: 6000, user: user2)
order27 = Order.create(amount: 7000, user: user2)
order28 = Order.create(amount: 8000, user: user2)
order29 = Order.create(amount: 9000, user: user2)
order30 = Order.create(amount: 10000, user: user2)
order31 = Order.create(amount: 11000, user: user2)
order32 = Order.create(amount: 12000, user: user2)
order33 = Order.create(amount: 13000, user: user1)
order34 = Order.create(amount: 14000, user: user1)
order35 = Order.create(amount: 15000, user: user1)
order36 = Order.create(amount: 16000, user: user1)
order37 = Order.create(amount: 17000, user: user1)
order38 = Order.create(amount: 18000, user: user1)
order39 = Order.create(amount: 19000, user: user1)
order40 = Order.create(amount: 20000, user: user1)
order41 = Order.create(amount: 11000, user: user2)
order42 = Order.create(amount: 12000, user: user2)
order43 = Order.create(amount: 13000, user: user1)
order44 = Order.create(amount: 14000, user: user1)
order45 = Order.create(amount: 15000, user: user1)
order46 = Order.create(amount: 16000, user: user1)
order47 = Order.create(amount: 17000, user: admin)
order48 = Order.create(amount: 18000, user: user2)
order49 = Order.create(amount: 19000.11, user: user1)
order50 = Order.create(amount: 20000.22, user: user1)

max_id = Order.maximum(:id)
Order.find_each { |ord| ord.update(created_at: ord.created_at - (86400 * 7 * (max_id - ord.id))) }

# Создаём несколько сохранений файлов (задание 2)
Preservation.create(initial_file_link: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf')
Preservation.create(initial_file_link: 'https://onlinetestcase.com/wp-content/uploads/2023/06/500-KB.pdf')
Preservation.create(initial_file_link: 'https://www.orimi.com/pdf-test.pdf')
