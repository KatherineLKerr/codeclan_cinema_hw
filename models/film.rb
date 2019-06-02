require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets ON tickets.customer_id = customers.id
    WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    result = customers.map {|customer| Customer.new(customer)}
    return result
  end

#CREATE

  def save
    sql = "INSERT INTO films
           (title, price)
           VALUES
           ($1, $2)
           RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

#UPDATE

  def update()
    sql = "UPDATE films SET
           (title, price)
           =
           ($1, $2)
           WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

#DELETE

  def delete()
    sql = "DELETE FROM films WHEREs id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

#READ

  def self.all
    sql = "SELECT * FROM films"
    film_hash = SqlRunner.run(sql)
    return film_hash.map { |film| Film.new(film) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    film_hash = results.first
    film = Film.new(film_hash)
    return film
  end

#BASIC EXTENSION

  def self.how_many_customers(film)
    film.customers.count
  end

end
