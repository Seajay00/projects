from translate import Translator

translator = Translator(from_lang = 'English' , to_lang = 'Russian')
result = translator.translate("Hi there")
print(result)
