# This example demonstrates a very common communication scenario: *application A* wants to publish a message that will end up in
# a queue that *application B* listens on.
#
# In this case, the queue name is "amqpgem.examples.hello".
#
# Let us go through the code step by step:

### Require AMQP library

# This is the simplest way to load the amqp gem if you have installed it with RubyGems.
require "rubygems"
require "amqp"

### Run EventMachine loop

# The following piece of code runs what is called the [EventMachine](http://rubyeventmachine.com) reactor. We will not go into what the term 'reactor' means here,
# but suffice it to say that the amqp gem is asynchronous and is based on an asynchronous network I/O library called _EventMachine_.
EventMachine.run do
  ### Establish connection

  # That one connects to the server running on localhost, with the default `port` (5672), `username` (guest), `password` (guest) and `virtual host` ('/').
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

  ### Create a channel

  # AMQP is a multi-channeled protocol that uses channels to multiplex a TCP connection.
  # Channels are opened on a connection, therefore the `AMQP::Channel` constructor takes a connection object as a parameter.
  # So, we open up a new `channel`.
  channel  = AMQP::Channel.new(connection)

  ### Declare a queue

  # Now we declare a `queue` on the `channel` that we have just opened. Consumer applications get messages from queues.
  # We declared this queue with the `auto-delete` parameter. Basically, this means that the queue will be deleted when there are no more processes
  # consuming messages from it.
  queue    = channel.queue("amqpgem.examples.helloworld", :auto_delete => true)
  exchange = channel.direct("")

  ### Subscribe to queue messages

  # `AMQP::Queue#subscribe` takes a block that will be called every time a message arrives.
  queue.subscribe do |payload|
    puts "Received a message: #{payload}. Disconnecting..."
    # `AMQP::Session#close` closes the AMQP connection and runs a callback that stops the EventMachine reactor.
    connection.close { EventMachine.stop }
  end

  ### Publish the message

  # Finally, we publish our message.
  # Routing key is one of the `message attributes`. The default exchange will route the message to a queue that has the same name
  # as the message's `routing key`. This is how our message ends up in the `amqpgem.examples.helloworld` queue.
  exchange.publish "Hello, world!", :routing_key => queue.name
end
