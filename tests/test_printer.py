import unittest
from pakettic import parser
from pakettic import printer
from pakettic.ast import *


class TestPrinter(unittest.TestCase):
    def test_printing_parsed_code(self):
        cases = [
            'a={42,x,0}',
            'a={[1]=5,[42]=0}',
            'a={x=2,y=4}',
            'a={42,x=4,[4]=1}',
            'obj:f(42)',
            'f=function(x)end',
            'f.foo=function(x)end',
            'f.bar=function(self,x)end',
            'f.foo.bar=function(self,x)end',
            'x=5',
            'x=-1^2',
            'x=(-1)^2',
            'x=2^-3',
            'x=-2^-3',
            'x=2^2^2',
            'x=(2^2)^2',
            'x=2^-2^2',
            'x=(2^-2)^2',
            'x=2^(-2)^2',
            'x=(2*2)^2',
            'x=2^(2*2)',
            'p.x=5',
            'p[5]=5',
            'p[5].x=5',
            'x,y=1,2',
            'local y=42',
            'do break end',
            'for i=1,10 do end',
            'for k,v in a do end',
            'x=0xac',
            'x=0xac x=0xff',
            '::foo::',
            'return 0',
            'goto foo goto bar',
            'while true do end',
            'repeat break until true',
            'if true then end',
            'if a==nil then end',
            'if true then else break end',
            'if true then elseif true then else break end',
            'debug()',
        ]
        for a in cases:
            with self.subTest(code=a):
                expected = parser.parse_string(a)
                printed = printer.format(expected)
                self.assertEqual(printed, a)
                got = parser.parse_string(printed)
                self.assertEqual(got, expected)
