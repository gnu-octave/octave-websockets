## Copyright 2006(?) Paul Kienzle <pkienzle@users.sf.net>
## Copyright 2015 Oliver Heimlich <oheim@posteo.de>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{Y} =} base64encode (@var{X})
## @deftypefnx {Function File} {@var{Y} =} base64encode (@var{X}, @var{row_vector})
## Convert @var{X} into string of printable characters according to RFC 2045.
##
## The input may be a string or a matrix of integers in the range 0..255.
##
## If want the output in the 1-row of strings format, pass the 
## @var{row_vector} argument as @code{true}.  Otherwise the output is a 4-row
## character matrix, which contains 4 encoded bytes in each column for each
## 3 bytes from the input.
## 
## Example:
## @example
## @group
## base64encode ('Hakuna Matata', true) 
##   @result{} SGFrdW5hIE1hdGF0YQ==
## @end group
## @end example
## @seealso{base64decode, base64_encode}
## @end deftypefn

function Y = base64encode (X, row_vector)
  if (nargin < 1 || nargin > 2)
    print_usage;
  endif
  
  if (nargin < 2)
    row_vector = false;
  endif
  
  if (ischar (X))
    X = double (X);
  endif
  
  if (any (X != fix (X)) || any (X < 0 | X > 255))
    error ("base64encode is expecting integers in the range 0 .. 255");
  endif

  Y = base64_encode (uint8 (X));

  if (not (row_vector))
     Y = reshape (Y, 4, []);
  end
endfunction
