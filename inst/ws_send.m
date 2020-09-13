## Copyright (C) 2020 M. Miretti <marco.miretti@gmail.com>
##
## This file is part of the websockets-package.
##
## The websockets-package is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3 of
## the License, or (at your option) any later version.
##
## The websockets-package is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{len} =} ws_send (@var{ws}, @var{data})
## @deftypefnx {Function File} {@var{len} =} ws_send (@var{ws}, @var{data}, @var{mode})
## @deftypefnx {Function File} {@var{len} =} ws_send (@var{ws}, @var{data}, @var{mode}, @var{mask})
##
## Send data to the WebSocket "ws".
##
## @noindent
## Given the:
## @itemize @bullet
## @item @var{ws}
## A websocket structure, containing a client and the characteristics of said websocket
## @item @var{data}
## The data that will be sent to the WebSocket.
## @item @var{mode}
## The data mode, an string that can be either "text", "binary", "ping" or "pong". If 
## this is not present, the text mode is used by default. In case of the last two, data
## is ignored.
## @item @var{mask}
## Either 1 or 0 indicating if the message will be masked or not respectively. The masking
## isn't implemented yet and is disabled by default. Enabling it will apply a zero mask to
## the data, keeping it the same.
## @end itemize
## @var{len} the quantity of bytes sent.
## 
## @end deftypefn

## Author:        M. Miretti
## Keywords:      websockets-package websockets send
## Directory:     octave-websockets/inst/
## Filename:      ws_send.m
## Last-Modified: 12 Sep 2020

function len = ws_send (ws, data, mode = 'text', mask = 0)
	
	true = 255;
	false = 0;

	% proto constants
	EXTENSION_1_FLAG = 126;
	EXTENSION_2_FLAG = 127;

	proto.payload_len = length(data);
	% continuation messages not yet supported
	proto.fin = true;

	switch mode
		case "text"
			proto.opcode = 1;
		case "binary"
			proto.opcode = 2;
		case "ping"
			proto.opcode = 9;
		case "pong"
			proto.opcode = 10;
		otherwise
			proto.opcode = -1;
			error('Invalid string passed as -mode-')
	endswitch

	switch mask
		case 0
			proto.is_masked = false;
		case 1
			% currently masked is not fully supported
			proto.is_masked = true;
			proto.mask = uint32(0);
		otherwise
			proto.is_masked = -1;
			error('Invalid value passed as -mask-')
	endswitch

	message = [bitand(128, proto.fin) + ...
		   bitand(15, proto.opcode)];

	if proto.payload_len > (2^16 + EXTENSION_1_FLAG)
		% this means we need two extensions (7 + 64 bits)
		len = uint64(proto.payload_len - 127);
		len_arr = flip(typecast(len, 'uint8'));
		message = [message, bitand(128, proto.is_masked) + ...
			   bitand(127, EXTENSION_2_FLAG), len_arr];
	elseif proto.payload_len > (125)
		% this means we can handle with 126 + uint16
		len = uint16(proto.payload_len - 126);
		len_arr = flip(typecast(len, 'uint8'));
		message = [message, bitand(128, proto.is_masked) + ...
			   bitand(127, EXTENSION_1_FLAG), len_arr];
	else
		% this means that len is less than 125
		message = [message, bitand(128, proto.is_masked) + ...
			   bitand(127, proto.payload_len)];
	endif

	if proto.is_masked
		message = [message, typecast(proto.mask, 'uint8'), ...
			   typecast(data, 'uint8')];
	else
		message = [message, typecast(data, 'uint8')];
	endif

	len = send(ws.client, message);

endfunction
