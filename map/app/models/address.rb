# encoding: UTF-8
require 'spreadsheet'
require 'csv'

class Address < ActiveRecord::Base
  acts_as_taggable
  geocoded_by :address
  after_validation :reset_geocode

  def reset_geocode
    if street_changed? || zipcode_changed? || city_changed? || country_changed?
      self.latitude = nil
      self.longitude = nil
      geocode
    end
  end

  def address
    if tag_list.include?("dealers") || tag_list.include?("locations")
      [self.street, "#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
    else
      ["#{self.zipcode} #{self.city}"].delete_if {|d| d.blank?}.collect{|d|d.strip}.join(", ")
    end
  end

  def products
    products = []

    products << "Bier"   if tag_list.include? "PB"
    products << "Cola"   if tag_list.include? "PC"
    products << "Kaffee" if tag_list.include? "PK"

    if products.size > 2
      "#{products[0..products.length-2].join(", ")} und #{products.last}"
    else
      products.join(", ")
    end
  end

  def distance(point)
    if distance_from(point).nil? 
      1.609344  
    else 
      distance_from(point) * 1.609344
    end
  end

  def self.parse_csv(file)
    row_num = 0
    Address.transaction do
      created_ids = []
      CSV.foreach(file, col_sep: ";", encoding: "iso-8859-15") do |row|
        row_num += 1
        next if row_num == 1
        addr = parse_row row
        created_ids << addr.id if addr
      end
    end
  end

  def self.parse_excel(file)
    spreadsheet = Spreadsheet.open file
    sheet = spreadsheet.worksheet 0
    row_num = 0
    Address.transaction do
      created_ids = []
      sheet.each do |row|
        row_num += 1
        next if row_num == 1
        addr = parse_row row
        created_ids << addr.id if addr
      end
      Address.delete_all(['id not in (?)', created_ids])
    end
  end

  def self.analyse_group(cell)
    if cell.kind_of? String
      cell.split(",").collect {|a| a.to_i}
    elsif !cell.nil?
      v = cell.to_s.split(".").map{|v| v.to_i}
      res = []
      res << v[0]
      if v.length > 1
        res << (v[1] < 10 ? v[1] * 10 : v[1])
      end
      res
    else
      []
    end
  end

  def self.parse_row(row)
    groups = analyse_group(row[19])
    # Kein Sprecher, Veranstaltungsort oder Händler ? Raus!
    return nil if (groups & [7,8,9]).length == 0
    # Kein Getränk angegeben und kein Sprecher? Raus!
    return nil if (groups & [20,21,22,23]).length == 0 && !groups.include?(7)

    web = row[18]
    web = "http://#{web}" if !web.nil? && !web.starts_with?("http://")

    unless row[9].nil?
      zip_code = row[9]

      unless zip_code.kind_of? String
        zip_code = zip_code.truncate.to_s
        while zip_code.length < 5
          zip_code = '0' + zip_code
        end
      end
    end

    addr = Address.find_or_create_by_collmex_id(
      row[0].to_i
    )

    addr.first_name = row[4]
    addr.last_name = row[5]
    addr.company = row[6]
    addr.street = row[8]
    addr.zipcode = zip_code
    addr.city = row[10]
    addr.country = row[13]
    addr.web = web
    addr.email = row[16]
    addr.telephone = row[14]
    addr.comment = row[30].to_s
    addr.tag_list << "speakers" if groups.include? 7
    addr.tag_list << "locations" if groups.include? 8
    addr.tag_list << "dealers" if groups.include? 9
    addr.tag_list << "PC" if groups.include?(20) || groups.include?(22)
    addr.tag_list << "PB" if groups.include?(21) || groups.include?(22)
    addr.tag_list << "PK" if groups.include? 23
    addr.save
    addr
  end

end
