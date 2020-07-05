require "sqlite3"

DB_NAME = "parking.db"
TABLE_NAME = "slots"

class DbOperation
  def initialize()
    @db = SQLite3::Database.open DB_NAME
  end

  def self.connect_database?
    connected = false
    begin
      SQLite3::Database.new DB_NAME unless File.exist?(DB_NAME)
      db = SQLite3::Database.open DB_NAME
      # puts "DB SQLITE_VERSION: #{db.get_first_value 'SELECT SQLITE_VERSION()'}"
      db.execute "CREATE TABLE IF NOT EXISTS #{TABLE_NAME}(id INTEGER PRIMARY KEY, reg_no INTEGER, color TEXT)"
      connected = true
    rescue SQLite3::Exception => e 
        puts "Exception occurred #{e}"
    ensure
        db.close if db
    end
    return connected
  end


  def insert(slot_count)
    begin
      @db.transaction #for fase performance
        1..slot_count.to_i.times do |i|
          @db.execute "INSERT INTO #{TABLE_NAME}(reg_no, color) VALUES('', '')"
        end
      @db.commit
      puts "#{slot_count} parking slots are created, you can view the status by command: `parking status` "
    rescue Exception => e
      puts "Exception occurred: #{e}"
    end
  end

  def update(vehicle_reg_no, vehicle_color)
    begin
      slot_no = @db.get_first_value "SELECT id FROM #{TABLE_NAME} WHERE reg_no = ?", vehicle_reg_no
      return puts "You reg. no. #{vehicle_reg_no} already have allocated to slot no. #{slot_no}" if slot_no
      slot_id = @db.get_first_value "SELECT * FROM #{TABLE_NAME} WHERE reg_no = '' ORDER BY id ASC limit 1"
      # puts "-RES--#{slot_id}--"
      return puts "Slot is not available, either create a new lot or wait for release the existing one" unless slot_id
      @db.query "UPDATE #{TABLE_NAME} SET reg_no = ?, color = ? WHERE id = ?", vehicle_reg_no, vehicle_color, slot_id.to_i
      puts "Vehicle of Reg no. #{vehicle_reg_no} is allocated to slot #{slot_id} successfully"
    rescue Exception => e
      puts "Exception occurred: #{e}"
    end
  end

  def delete(slot_id)
    begin
      query_slot_id = @db.get_first_value "SELECT id FROM #{TABLE_NAME} WHERE id = ? AND reg_no != '' ", slot_id.to_i
      # puts "--query slo---#{query_slot_id}"
      return puts "Entered slot no. #{slot_id} is invalid" unless query_slot_id
      # @db.query "DELETE FROM #{TABLE_NAME} WHERE id = ?", query_slot_id
      @db.query "UPDATE #{TABLE_NAME} SET reg_no = ?, color = ? WHERE id = ?", "", "", query_slot_id.to_i
      puts "Slot #{query_slot_id} is released"
    rescue Exception => e
      puts "Exception occurred #{e}"
    end
  end

  def list
    begin
      return @db.execute "SELECT * FROM #{TABLE_NAME}"  
    rescue Exception => e
      puts "Exception occurred #{e}"
    end
  end
  
end
