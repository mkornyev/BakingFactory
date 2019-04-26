namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    require 'factory_bot_rails'
    require './lib/tasks/populator'
    include Populator

    # Step 0: Reset of the databases (restart from scratch)
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    puts "Reset the dev and test databases"

    # Step 1: Create admins and workers
    create_employees
    puts "Created admins and workers"

    # Step 2: Create some items and prices for each
    create_breads_and_prices
    puts "Created breads and associated price histories"
    create_muffins_and_prices
    puts "Created muffins and associated price histories"
    create_pastries_and_prices
    puts "Created pastries and associated price histories"

    # Step 3: Create 120 customers and their associated users
    all_customers = create_customers
    puts "Created 120 customers"

    # Step 4: for each customer associate some addresses
    create_addresses_for(all_customers)
    puts "Created a set of addresses for each customer"

    # Step 5: Create some orders for each customer
    create_orders_for(all_customers)
    puts "Created orders for customers"
  end
end