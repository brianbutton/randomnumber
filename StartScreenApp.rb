require 'gosu'
require_relative 'RandomNumberApp'

class StartScreenApp < Gosu::Window
  def initialize
    super 1000, 600
    self.caption = "Set Number Range and Counters"

    @font = Gosu::Font.new(30)
    @font_large = Gosu::Font.new(50)

    @input_min = ''
    @input_max = ''
    @input_counters = ''
    @input_stage = :min
  end

  def update
    handle_input
  end

  def draw
    draw_start_screen
  end

  def draw_start_screen
    @font_large.draw_text("Enter the range for numbers:", 100, 100, 1)

    case @input_stage
    when :min
      @font.draw_text("Min: #{@input_min} (Press Enter when done)", 100, 200, 1)
    when :max
      @font.draw_text("Min: #{@input_min}", 100, 200, 1)
      @font.draw_text("Max: #{@input_max} (Press Enter when done)", 100, 240, 1)
    when :counters
      @font.draw_text("Min: #{@input_min}", 100, 200, 1)
      @font.draw_text("Max: #{@input_max}", 100, 240, 1)
      @font.draw_text("Counters (1-8): #{@input_counters} (Press Enter when done)", 100, 280, 1)
    end

    if @input_min != '' && @input_max != '' && @input_counters != ''
      @font.draw_text("Press Enter to confirm", 100, 340, 1)
    end
  end

  def handle_input
    if Gosu.button_down?(Gosu::KB_BACKSPACE)
      case @input_stage
      when :min
        @input_min.chop! unless @input_min.empty?
      when :max
        @input_max.chop! unless @input_max.empty?
      when :counters
        @input_counters.chop! unless @input_counters.empty?
      end
    elsif Gosu.button_down?(Gosu::KB_RETURN)
      case @input_stage
      when :min
        @input_stage = :max unless @input_min.empty?
      when :max
        @input_stage = :counters unless @input_max.empty?
      when :counters
        if @input_counters.to_i.between?(1, 8)
          start_random_number_app(@input_min.to_i, @input_max.to_i, @input_counters.to_i)
          close
        end
      end
    else
      handle_numeric_input
    end
  end

  def handle_numeric_input
    (Gosu::KB_1..Gosu::KB_0).each_with_index do |key, i|
      if Gosu.button_down?(key)
        char = (i + 1) % 10
        case @input_stage
        when :min
          @input_min += char.to_s
        when :max
          @input_max += char.to_s
        when :counters
          @input_counters += char.to_s if @input_counters.length < 1
        end
        sleep(0.2) # To prevent rapid multiple inputs
      end
    end
  end

  def start_random_number_app(min, max, counters)
    RandomNumberApp.new(min, max, counters).show
  end
end

StartScreenApp.new.show
