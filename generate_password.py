print("Hello World!")

import random

passwords_file = '''password
000000
000001
111111
QWERTY
123456
pussy
rrrrrr
999999
112233
qqqqqq
ddd
dggsaa
'''


class BadPasswordGenerator:
    def __init__(self, length=10):
        # self.length = length
        # self.passwords=length
        self.passwords = passwords_file.split()
        self.index = 0

    def generate(self):
        if self.index >= len(self.passwords):
            raise ValueError('Пароли иссякли')

        password = self.passwords[self.index]
        self.index += 1
        return password


bad_gen = BadPasswordGenerator()
print(len(bad_gen.passwords))
print(bad_gen.generate())
print(bad_gen.generate())
print(bad_gen.generate())
print(bad_gen.generate())
print(bad_gen.generate())


class GoodPasswordGenerator:
    def __init__(self, length=10):
        self.length = length
        self.alphabet = '0123456789' \
                        'kjdfgkjdkgjdfgdfgj;oieuiyvmcnvb' \
                        'QWERTYUIOP{ASDFGHJKLZXCVBNM' \
                        '!@#$%^&*()?"}>:{|"'
        self.length = 4

    def generate(self):
        password = ''
        for i in range(self, length=10):
            symbol = random.choice(self.choice(self.alphabet))
            password += symbol
        return password


# good_gen5 = GoodPasswordGenerator(length=5)
# good_gen10 = GoodPasswordGenerator()
# print(good_gen10.alphabet)
# print(len(good_gen10.alphabet))
# print(good_gen10.length,good_gen10.length)
# print(good_gen10.generate(),good_gen10.generate())
# a=ramdom.randint(0,88)


# ПАРСИНГ САЙТОВ

import requests

response = requests.get('https://google.com')
print(response.status_code)
# print(response.text)

# ДЗ : брутфорс сайтов