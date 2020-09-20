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
## @deftypefn {Function File} {@var{key} =} generate_secret_key ()
##
## @noindent
## Generate a base64-encoded key from a random set of 4 single precision floats.
## @noindent
## Return:
## @itemize @bullet
## @item @var{key}
## a base64 encoded string of 24 characters
## @end itemize
## @end deftypefn
##
## @example
## key_len = length(generate_secret_key ())
## -| key_len = 24
## @end example

## Author:        M. Miretti
## Keywords:      websockets-package websockets private key-generation
## Directory:     octave-websockets/inst/private/
## Filename:      generate_secret_key.m
## Last-Modified: 2 Sep 2020

function key = generate_secret_key ()

	key =  base64_encode(rand([1 4], "single"));

endfunction
