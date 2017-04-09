class Instance < ActiveRecord::Base
  validates :ip, uniqueness: true
  validate :validate_ip_address
  after_create :start_collection

  def statistics(from, to)
    { average_rtt: 666 }
  end

  def process
    collect unless destroyed?
  end

  def collect
    result = `ping #{ip} -c 1`
    rtt = result.match(/(stddev =\s)([^(\/)]*)(\/)/)[2].to_f
    transmitted = result.match(/(\d*)(\spackets transmitted)/)[1]
    received = result.match(/(\d*)(\spackets received)/)[1]
    metric = Metric.create(ip: ip, rtt: rtt, transmitted: transmitted, received: received)
    collect
  end

  def validate_ip_address
    (IPAddr.new(ip) rescue nil) || errors.add(:ip, "Incorrect address.")
  end
end
