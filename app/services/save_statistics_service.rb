class SaveStatisticsService
  PING_COUNT = 10

  attr_reader :node, :start_time

  def initialize(node:, start_time:)
    @node = node
    @start_time = start_time
  end

  def execute
    stdout, _stderr, status = run_ping_command
    return unless status.success?

    save_statistics(stdout)
  end

  private

  def run_ping_command
    host = node.ip_address
    command = "ping -c #{PING_COUNT} #{host}"
    Open3.capture3(command)
  end

  def save_statistics(stdout)
    output = stdout.split("\n")
    average_rtt, min_rtt, max_rtt, median_rtt, stddev_rtt, packet_loss_rate = calculate_metrics(output)
    statistics = node.statistics.build(
      average_rtt: average_rtt,
      minimum_rtt: min_rtt,
      maximum_rtt: max_rtt,
      median_rtt: median_rtt,
      standard_deviation: stddev_rtt,
      percentage_lost: packet_loss_rate,
      start_time: start_time,
      end_time: Time.now
    )

    statistics.save
  end

  def calculate_metrics(output)
    rtt_lines = select_rtt_lines(output)
    rtt_values = extract_rtt_values(rtt_lines)
    average_rtt = calculate_average_rtt(rtt_values)
    min_rtt = rtt_values.min
    max_rtt = rtt_values.max
    median_rtt = calculate_median_rtt(rtt_values)
    stddev_rtt = calculate_stddev_rtt(rtt_values, average_rtt)
    packet_loss_rate = calculate_packet_loss_rate(output)

    [average_rtt, min_rtt, max_rtt, median_rtt, stddev_rtt, packet_loss_rate]
  end

  def select_rtt_lines(output)
    output.select { |line| line =~ /^[0-9]+ bytes from/ }
  end

  def extract_rtt_values(rtt_lines)
    rtt_lines.map { |line| line.split("time=")[1].split(" ms")[0].to_f }
  end

  def calculate_average_rtt(rtt_values)
    rtt_values.sum / rtt_values.size
  end

  def calculate_median_rtt(rtt_values)
    sorted_rtt = rtt_values.sort

    sorted_rtt[rtt_values.size / 2]
  end

  def calculate_stddev_rtt(rtt_values, average_rtt)
    Math.sqrt(rtt_values.map { |x| (x - average_rtt) ** 2 }.sum / rtt_values.size)
  end

  def calculate_packet_loss_rate(output)
    stats_line = output.select { |line| line =~ /^[0-9]+ packets transmitted/ }[0]
    packets_received = stats_line.split(",")[1].split(" ")[0].to_i
    packets_transmitted = stats_line.split(" ")[0].to_i

    (1 - packets_received.to_f / packets_transmitted) * 100
  end

end
