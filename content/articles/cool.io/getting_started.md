TimerWatcher allows you to create one-shot timers

From Libev guides: Configure the timer to trigger after after seconds. If repeat is false, then it will automatically be stopped once the timeout is reached. If it is true, then the timer will automatically be configured to trigger again repeat seconds later, again, and again, until stopped manually.

watcher = Cool.io::TimerWatcher.new(interval, true)
watcher.attach(Cool.io::Loop.default)

another way to do so would be to subclass a TimeWatcher:

Cool.io::Loop.default.run

class SimpleTimerWatcher < Cool.io::TimerWatcher
  def initialize args

  end
  def on_timer
    TMP.succ!
  end
end
