require 'open-uri'
require 'nokogiri'
require 'csv'

res = (1..195).reduce([]) do |sum, index|
  doc = Nokogiri::HTML(open("http://www.bornprettystore.com/show.php?page=#{index}"))
  page_data = doc.css('dl.J_pro_items').map do |dl|
    image = dl.css('img.J_first_pic').first['data-ks-lazyload']
    title = dl.css('dd.pro_list_tit a').first.content
    red_price = dl.css('.light_red em').first.content
    product_link = dl.css('a').first['href']
    [image, title, red_price, product_link]
  end
  sum.concat(page_data)
end

CSV.open('./products.csv', 'wb') do |csv|
  csv << ['img', 'title', 'price', 'product_link']
  res.each do |row|
    csv << row
  end
end
