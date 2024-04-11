import pandas as pd
import re

def open_file(file):
  profanity_df = pd.read_csv(file)
  profanity_text = (list(profanity_df['text']))
  profanity_canonical = (list(set(profanity_df['canonical_form_1'])))
  profanity_words = profanity_text + profanity_canonical

  # List of bad text not in original csv
  profanity_words.extend(['s3x', '$ex', '$#x', 'a$$', '@$$', '@ss'])

  return profanity_words

def process_input():
  print('Enter a description for your pin: ')
  description = input()   # takes user input
  description = re.split(r'\s|[,;./]+', description) # splits string on this list of characters along with a normal space

  return description

def check_description(description):
  bad_words = set()
  for bad_word in profanity_words:
    if bad_word in pin_description:
      bad_words.add(bad_word)
  if len(bad_words) == 0:
    return 'None'
  else:
    return bad_words

profanity_words = open_file('profanity_en.csv')
pin_description = process_input()
print('Bad words detected: ', check_description(pin_description))