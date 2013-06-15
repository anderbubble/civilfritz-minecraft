# A Puppet module for minecraft servers

`civilfritz-minecraft` installs and manages a [Minecraft][] server, and
bundles just enough scripting to make it behave like a regular system
service.

[Minecraft]: https://minecraft.net

## Examples

As usual, you are just a single include away from a working service.

    include minecraft

Of course, you can also configure your server, using either [hiera] [1] or
class parameters.

    class { 'minecraft':
        level_name => 'civilfritz',
        level_seed => 'civilfritz',
        motd       => 'civilfritz Minecraft server',
    }

[1]: http://docs.puppetlabs.com/hiera/1/index.html

## Server interaction

A common idiom in the Minecraft server world is to start the server in
a `screen` session, creating a makeshift daemon with access to the
console.  `civilfritz-minecraft` avoids this by attaching the
Minecraft server process to a named pipe.  The Minecraft server is run
directly by `init`, and can be stopped, started, and reloaded using
the system service control mechanism.

    # invoke-rc.d minecraft restart

Issue arbitrary commands to the server by writing into the named pipe.

    $ echo "/say Hello, world!" >/var/run/minecraft/minecraft_server

## Operating system support

Right now, `civilfritz-minecraft` only supports the Debian `osfamily`.
Red Hat support should follow, but will likely require a separate
`init` script.

## Dependencies

`civilfritz-minecraft` uses `wget` to download `minecraft_server.jar`.

    Package['wget'] -> Class['minecraft::install']

## Contact

[Jonathon Anderson](janderson@civilfritz.net)

## Support

Please log tickets and issues at [GitHub] [2].

[2]: https://github.com/anderbubble/civilfritz-minecraft

## License

Copyright (c) 2013, Jonathon Anderson
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
- Neither the name of civilfritz.net nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHON
ANDERSON BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
