import pandas as pd
import re

def open_df(df):
  profanity_text = (list(df['text']))
  profanity_canonical = (list(set(df['canonical_form_1'])))
  profanity_words = profanity_text + profanity_canonical

  # List of bad text not in original csv
  profanity_words.extend(['s3x', '$ex', '$#x', 'a$$', '@$$', '@ss'])

  return profanity_words

def process_input(comment):
  comment = re.split(r'\s|[,;./]+', comment) # splits string on this list of characters along with a normal space

  return comment

def check_description(description, badWords):
  bad_words = set()
  for bad_word in description:
    if bad_word in badWords:
      bad_words.add(bad_word)
  if len(bad_words) == 0:
    return 'None'
  else:
    return bad_words
