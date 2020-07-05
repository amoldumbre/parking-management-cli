require "thor"

require "parking_slot/version"
require "parking_slot/db_operation"
require "console_table"
require "colorize"
# require "readline" #---Will require for adding prefix of CLI

module ParkingSlot

  class Error < StandardError; end

  class ParkingSlotCLI < Thor
    def initialize(*args)
      @db_object = DbOperation.new()
      super
    end


    desc "create [number]", "Create a new parking lot consists of many number of individual slots"
    def create(lot_count)
      @db_object.insert(lot_count)
      status
    end

    desc "allocate [registration_number], [color]", "Park or allocate the vehicle in available parking slot"
    def allocate(reg_no, color)
      slot_id = @db_object.update(reg_no, color)
      status
    end

    desc "leave [slot_no]", "Release the allocated slot"
    def leave(slot_id)
      @db_object.delete(slot_id)
      status
    end

    desc "status", "Parking Status"
    def status
      # veh_colors = String.colors.reject! {|color| color == :white || color == :light_white }
      # [:black, :light_black, :red, :light_red, :green, :light_green, :yellow, :light_yellow, :blue, :light_blue, :magenta, :light_magenta, :cyan, :light_cyan, :white, :light_wh
      # ite, :default]
      table_config = [
         # {key: :sr_no, size: 15, title: "Sr. No.", justify: :center },
         {key: :id, size: 15, title: "Slot No.", justify: :center },
         {key: :reg_no, size: 15, title: "Registration No.", justify: :center },
         {key: :color, size: 15, title: "Color", justify: :center }
      ]
      ConsoleTable.define(table_config) do |table|
        @db_object.list.each_with_index do |record, index|
          # puts "-STR----#{String.colors.find_index(record[2])}--"
          veh_color = ""#ParkingSlotCLI.new.send("#{record[0]}".to_sym, String.colors.find_index(record[2].index).to_sym)
          # String.colors.find_index(record[2].index)
          # "#{record[2]}".green
          table << {
            # sr_no: "#{index+1}".red, #Uses 'colorize' gem
            id: "#{record[0]}".red,
            reg_no: "#{record[1]}".blue,
            color: "#{record[2]}".green
          }
        end
      end      
    end

    desc "exit", "Logout from system"
    def exit
      puts "exit"
    end

    # def help
      
    # end

  end

end

ParkingSlot::ParkingSlotCLI.start(ARGV)

# while line = Readline.readline('parking >> ', true)
#   break if line == "exit"
#   p "1. allocate"
#   n = gets.chomp
#   ParkingSlot::ParkingSlotCLI.new.allocate() if n == 1
#   # ParkingSlot::ParkingSlotCLI.start(ARGV)
# end      