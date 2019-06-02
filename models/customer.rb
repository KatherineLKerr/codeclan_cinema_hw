require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end


  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map {|film| Film.new(film)}
    return result
  end

#CREATE

  def save
    sql = "INSERT INTO customers
           (name, funds)
           VALUES
           ($1, $2)
           RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

#UPDATE

  def update()
    sql = "UPDATE customers SET
           (name, funds)
           =
           ($1, $2)
           WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

#DELETE

  def delete()
    sql = "DELETE FROM customers WHEREs id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

#READ

  def self.all
    sql = "SELECT * FROM customers"
    customer_hash = SqlRunner.run(sql)
    return customer_hash.map { |customer| Customer.new(customer) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    customer_hash = results.first
    customer = Customer.new(customer_hash)
    return customer
  end


end
