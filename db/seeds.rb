# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'ffaker' #Using faker to seed make-believe data
require 'csv' #Pull data from local .csv files

# Seed zip_code and states tables via SQL import
#csv_text = File.read("#{Rails.root}/db/state_table.csv")
#csv = CSV.parse(csv_text, :headers => true)
#csv.each do |row|
#  State.create!(row.to_hash)
#end

#csv_text = File.read("#{Rails.root}/db/zip_code_table.csv")
#csv = CSV.parse(csv_text, :headers => true)
#csv.each do |row|
#  ZipCode.create!(row.to_hash)
#end

# Generate transaction types
TransactionType.create(id: 1, name: 'ATM_Withdrawal')
TransactionType.create(id: 2, name: 'Check')
TransactionType.create(id: 3, name: 'Deposit')
TransactionType.create(id: 4, name: 'Auto-draft')
TransactionType.create(id: 5, name: 'POS')
TransactionType.create(id: 6, name: 'Transfer')
TransactionType.create(id: 7, name: 'Withdrawal')
TransactionType.create(id: 8, name: 'Interest')
TransactionType.create(id: 99, name: 'Miscellaneous')
# Generate account types
AcctType.create(id: 1, name: 'savings', interest_rate: 0.99)
AcctType.create(id: 2, name: 'checking', interest_rate: 0.000)

# Generate 100 users (with "customer" role) (Admins created separately)
users = [] # Empty array to store users
20.times do
	username = "#{FFaker::Vehicle.make}#{FFaker::BaconIpsum.word}-#{rand(999)}"
	user_password = SecureRandom.base64(12)
	u = User.new
		u.id = SecureRandom.uuid
		u.username = username.gsub(/\s+/,"")
		u.password = user_password
		u.password_confirmation = user_password
		u.email = "#{FFaker::Internet.free_email}"
		u.sign_in_count = 0
		# u.role_id = 2
	u.save
	users << u # Put newly created user in the array
end

# Generate a regular ("Test") user - will be the 100th seeded user
testUser = User.create(id: SecureRandom.uuid, username: 'user', password: 'password', password_confirmation: 'password', email: 'foo@bar.com', sign_in_count: 0)
users << testUser # Store "test" user in the users array

# Generate admin ("Administrator") user
seeded_admin_id = SecureRandom.uuid # Created variable because it's used twice
User.create(id: seeded_admin_id, username: 'admin', password: 'Pa55w0rd', password_confirmation: 'Pa55w0rd', email: 'phill@capstonesavings.com', sign_in_count: 0, role: 'admin')

# Set up profile for above created admin user ADMIN_ID IS 10 ONES
Administrator.create(id: 1111111111, firstname: 'Peggy', lastname: 'Hill', user_id: seeded_admin_id)

# Generate 100 customers
customers = [] # Empty array to store customers
20.times do |i|
	c = Customer.new
		user_id = User.select(:user_id).distinct

		firstname = nil
		lastname = "#{FFaker::Name.html_safe_last_name}"
		name_prefix = nil

		case rand(1..11)
			when 1,2,3,4
				name_prefix = 'Mr.'
			when 5,6
				name_prefix = 'Dr.'
			when 7,8,9,10
				name_prefix = 'Ms.'
			when 11
				name_prefix = 'Mx.'
		end

		case (name_prefix)
			when 'Mr.'
				firstname = "#{FFaker::Name.first_name_male}"
			when 'Ms.'
				firstname = "#{FFaker::Name.first_name_female}"
			when 'Dr.', 'Mx.'
				firstname = "#{FFaker::Name.first_name}"	
		end

		c.user_id = users[i].id
		c.id = SecureRandom.random_number(999999999) # 9-digit integer
		c.phone1 = "#{FFaker::PhoneNumber.short_phone_number}"
		c.phone2 = "#{FFaker::PhoneNumber.short_phone_number}"
		c.title = name_prefix
		c.firstname = firstname
		c.lastname = lastname
		c.user.update(email: "#{FFaker::Internet.free_email(c.firstname)}")
	c.save
	customers << c
end

# Generate 100 addresses for addresses table to be assigned to customers
20.times do |i|
	a = Address.new
		address1 = "#{FFaker::Address.street_address}"
		city = "#{FFaker::Address.city}"
		zipcode = "#{FFaker::AddressFI.zip_code}"
		state = "#{FFaker::AddressDA.region}"
		country = "#{FFaker::Address.country}"

		secondary_address = nil
		case rand(1..2)
			when 1 
				secondary_address = "#{FFaker::Address.secondary_address}"
			when 2 
				secondary_address = nil
		end

		a.customer_id = customers[i].id
		a.address1 = address1
		a.address2 = secondary_address
		a.city = city
		a.zip_code_zip_code = zipcode
		a.state = state
		a.country = country
	a.save
end

# Generate the first 100 accounts
accounts = []
20.times do |i|
    a = Account.new
    	a.customer_id = customers[i].id
    	a.acct_type_id = rand(1..2)
    	a.id =  SecureRandom.random_number(999999999999) # 12-digit account number
    	a.balance = (5000000.0 - 5.0) * rand() + 5
    	a.date_opened = rand(30.years).seconds.ago
    a.save
    accounts << a
end    
    # Generate initial deposits
    acct = Account.last
    payees =[]
100.times do |i|  
    Payee.create! do |payee|
        payee.ref_name = customers[i].name
        payee.bank_name = "Meijer Financial Services"
        payee.address = "#{FFaker::AddressCHIT.street_address}" 
        payee.acct_number = accounts[i].id
        payee.city = "#{FFaker::AddressCHIT.city}"
        payee.state = "#{FFaker::AddressCHIT.canton}"
        payee.country = "#{FFaker::AddressCHIT.country}"
        payee.post_code = "#{FFaker::AddressCHIT.postal_code}"
        payee.save
        payees << payee
    end
end    
    paye = Payee.last
100.times do |i|   
    AcctTransaction.create! do |transaction|
			transaction.id = SecureRandom.random_number(99999999999999)
			transaction.payee_id = paye.id
			transaction.account_id = accounts[i].id
			transaction.recipient_id = acct.id
			transaction.secure_tac = SecureRandom.random_number(99999999999999)
			transaction.transaction_type_id = 3
			transaction.status = "processed"
			transaction.description = "Initial Deposit"
			transaction.amount = (200000.0 - 5.0) * rand() + 5
			transaction.adjusted_bal = accounts[i].balance + transaction.amount
			transaction.date = accounts[i].date_opened
		acct.update(balance: transaction.adjusted_bal)
	end
end

# Generate 50 more (secondary) accounts ("Some customers have more than 1 account")
10.times do |i|
    a = Account.new
    	a.customer_id = customers[i].id
    	a.acct_type_id = rand(1..2)
    	a.id =  SecureRandom.random_number(999999999999) 
    	a.balance = 0
    	a.date_opened = rand(30.years).seconds.ago
    a.save
    accounts << a
    # Generate initial deposits
    acct = Account.last
    payees =[]
    Payee.create! do |payee|
        payee.ref_name = customers[i].name
        payee.bank_name = "Meijer Financial Services"
        payee.address = "#{FFaker::AddressCHIT.street_address}" 
        payee.acct_number = accounts[i].id
        payee.city = "#{FFaker::AddressCHIT.city}"
        payee.state = "#{FFaker::AddressCHIT.canton}"
        payee.country = "#{FFaker::AddressCHIT.country}"
        payee.post_code = "#{FFaker::AddressCHIT.postal_code}"
        payee.save
        payees << payee
    end
    paye = Payee.last
    AcctTransaction.create! do |transaction|
			transaction.id = SecureRandom.random_number(99999999999999)
			transaction.payee_id = paye.id
			transaction.account_id = accounts[i].id
			transaction.recipient_id = acct.id
			transaction.secure_tac = SecureRandom.random_number(99999999999999)
			transaction.transaction_type_id = 3
			transaction.status = "processed"
			transaction.description = "Initial Deposit"
			transaction.amount = (200000.0 - 5.0) * rand() + 5
			transaction.adjusted_bal = accounts[i].balance + transaction.amount
			transaction.date = accounts[i].date_opened
		acct.update(balance: transaction.adjusted_bal)
	end
end

# Generate historical transactions (AcctTransactions) for each account
descriptions_ATM_Withdrawal = ['Bank Of Skyland ATM - Skyland, NC',
					'Citi Store ATM - Columbus, OH',
					'Jaspers Mini Mart ATM - Sweetwater, TX',
					'Cash Pints ATM - Black Mountain, NC',
					'TE Bank ATM - Charlotte, NC']
descriptions_Check = ['Check 1001',
					  'Check 1002',
					  'Check 1003',
					  'Check 1004',
				      'Check 1005']
descriptions_Deposit = ['Cash Deposit - ATM',
						'Check Deposit - ATM',
						'Check Image Deposit - Mobile',
						'Check Image Deposit - PC',
						'Credit/Debit Deposit',
						'Direct Payroll Deposit']			      				
descriptions_AutoDraft = ['Unified Healthcare - Premium Payment',
						  'Luke Energy Payment',
						  'North Taxolina Dept. of Revenue Payment',
						  'CodeUniversity',
						  'NetMovies',
						  'Nine Rivers Country Club - Membership Dues']
descriptions_POS = ['Jingles Markets POS Transaction',
					'EM-Bark Fuels POS Transaction',
					'Delk Department Stores POS Transaction',
					'Rudys Rib Shack POS Transaction',
					'Minas Muffler and Brake POS Transaction',
					'What-a-Burger POS Transaction',
					'Strickland Propane POS Transaction',
					'Mega Lo Mart POS Transaction']
descriptions_Transfer = 'Transfer'
descriptions_Withdrawal = 'Withdrawal'
descriptions_Miscellaneous = 'Miscellaneous'

atm_amounts = [20.00,40.00,60.00,80.00,100.00,120.00,140.00,160.00,180.00,200.00]
types = [1,2,3,4,5,6,7,99]


accounts.each do |account|
	100.times do
		# puts account.balance
		type = types.sample
			case (type)
				when 1
					description = descriptions_ATM_Withdrawal.sample
					amount = (atm_amounts.sample) *-1
				when 2
					description = descriptions_Check.sample
					amount = ((500000.0 - 5.0) * rand() + 5) *-1
				when 3
					description = descriptions_Deposit.sample
					amount = (200000.0 - 5.0) * rand() + 5
				when 4
					description = descriptions_AutoDraft.sample
					amount = ((350.0 - 5.0) * rand() + 5) *-1
				when 5
					description = descriptions_POS.sample
					amount = ((150.0 - 5.0) * rand() + 5) *-1
				when 6
					description = descriptions_Transfer
					amount = (500000.0 - 5.0) * rand() + 5
				when 7
					description = descriptions_Withdrawal
					amount = ((50000.0 - 5.0) * rand() + 5) *-1
				when 99
					description = descriptions_Miscellaneous
					amount = ((500.0 - 5.0) * rand() + 5) *-1
			end
		next if (type != 3) && (amount.abs > account.balance)
		AcctTransaction.create! do |transaction|
			transaction.id = SecureRandom.random_number(99999999999999)
			transaction.account_id = account.id
			transaction.payee_id = paye.id
			transaction.recipient_id = acct.id
			transaction.secure_tac = SecureRandom.random_number(99999999999999)
			transaction.transaction_type_id = type
			transaction.description = description
			transaction.status = "processed"
			transaction.amount = amount
			transaction.adjusted_bal = account.balance + transaction.amount
			# keep transaction in chronological order unless it's the first one
			unless AcctTransaction.exists?(account_id: transaction.account_id)
				transaction.date = rand(account.date_opened..Time.now)
			else
				transaction.date = rand(AcctTransaction.where(account_id: transaction.account_id).last.date..Time.now)
			end
		account.update(balance: transaction.adjusted_bal)

		end
    end
end