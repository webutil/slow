# Slow

Test your timeout handlers http://slow.webutil.in

Allows you to test timeouts in your code.

## Examples

    # takes at least 1 second to respond
    curl https://slow.webutil.in/timeout?seconds=1

    # takes at least 10 microseconds to respond
    curl https://slow.webutil.in/timeout?microseconds=10
