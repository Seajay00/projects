import random

var = ['hand', 'leg', 'hip']
counter = 0
while True:
    counter += 1
    selection = input('Try to guess the world ("hip, leg or hand")\nEnter your choice:')
    if selection not in var:
        print('Your choice does not exist')
        print('continue...')
        counter = 0
        print(counter)
        continue
    sel = random.choice(var)

    print(counter)
    print('Your selection: ', selection)
    print('Random selection: ', sel)

    if counter >= 3:
        break
