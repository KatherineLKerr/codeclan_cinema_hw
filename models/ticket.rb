require_relative("../db/sql_runner")
require_relative("film")
require_relative("customer")

class Ticket

  attr_accessor :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
  end

#CREATE

  def save
    sql = "INSERT INTO tickets
           (customer_id, film_id)
           VALUES
           ($1, $2)
           RETURNING id"
    values = [@customer_id, @film_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

#UPDATE

  def update()
    sql = "UPDATE tickets SET
           (customer_id, film_id)
           =
           ($1, $2)
           WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

#DELETE

  def delete()
    sql = "DELETE FROM tickets WHEREs id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

#READ

  def self.all
    sql = "SELECT * FROM tickets"
    ticket_hash = SqlRunner.run(sql)
    return ticket_hash.map { |ticket| Ticket.new(ticket) }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    ticket_hash = results.first
    ticket = Ticket.new(ticket_hash)
    return ticket
  end

end
