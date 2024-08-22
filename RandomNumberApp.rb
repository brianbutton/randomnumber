require 'gosu'

class RandomNumberApp < Gosu::Window
  BUTTON_X = 150
  BUTTON_Y = 70
  BUTTON_WIDTH = 100
  BUTTON_HEIGHT = 30

  def initialize(min, max, counters)
    super 1000, 600
    self.caption = "Random Number Generator"

    @font = Gosu::Font.new(30)
    @font_large = Gosu::Font.new(50)

    @min = min
    @max = max
    @counters = counters
    @selected_counter = 0
    @last_press_time = 0

    @number_history = Array.new(counters) { [] }
  end

  def update
    if Gosu.button_down?(Gosu::KB_TAB) && (Gosu.milliseconds - @last_press_time > 200)
      @selected_counter = (@selected_counter + 1) % @counters
      @last_press_time = Gosu.milliseconds
    end

    if Gosu.button_down?(Gosu::KB_SPACE) && (Gosu.milliseconds - @last_press_time > 200)
      new_number = rand(@min..@max)
      @number_history[@selected_counter].unshift(new_number)
      @last_press_time = Gosu.milliseconds
    end
  end

  def draw
    draw_main_screen
  end

  def draw_main_screen
    @number_history.each_with_index do |history, index|
      color = index == @selected_counter ? Gosu::Color::RED : Gosu::Color::WHITE
      current_number = history.first || '-'
      @font_large.draw_text("Counter #{index + 1}: #{current_number}", 100, 100 + index * 60, 1, 1.0, 1.0, color)
      @font.draw_text("History: " + history.join(", "), 400, 110 + index * 60, 1)
    end

    @font.draw_text("Press TAB to switch counters", 100, 500, 1)
    @font.draw_text("Press SPACE to generate number", 100, 550, 1)
  end
end
