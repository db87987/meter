class Instance < ActiveRecord::Base
  validates :ip, uniqueness: true
  validate :validate_ip_address
  after_save :process

  def statistics(from, to)
    { average_rtt: 666 }
  end

  def process
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        collect if Instance.exists?(id)
      end
    end
  end

  def collect
    while Instance.exists?(id)
      result = `ping #{ip} -c 2`
      rtt = result.match(/(stddev =\s)([^(\/)]*)(\/)/)[2].to_f
      transmitted = result.match(/(\d*)(\spackets transmitted)/)[1]
      received = result.match(/(\d*)(\spackets received)/)[1]
      metric = Metric.create(ip: ip, rtt: rtt, transmitted: transmitted, received: received)
      collect
    end
  end

  def validate_ip_address
    (IPAddr.new(ip) rescue nil) || errors.add(:ip, "Incorrect address.")
  end
end
