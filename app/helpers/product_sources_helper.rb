module ProductSourcesHelper
  def currency_select_list
    currencies = []
    Money::Currency.table.each do |currency|
      name = currency[1][:iso_code]
      iso_code = currency[1][:iso_code].to_s
      currencies << [name, iso_code]
    end
    return currencies
  end
end
