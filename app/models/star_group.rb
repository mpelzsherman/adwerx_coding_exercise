class StarGroup < ActiveRecord::Base
  def self.all
    sql = %Q(select floor(num_stars / 200) * 200 as stargroup, count(*)
          from projects group by stargroup order by stargroup desc)
    ActiveRecord::Base.connection.execute(sql)
  end
end
