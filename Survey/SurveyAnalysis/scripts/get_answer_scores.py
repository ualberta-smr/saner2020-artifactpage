##Given a set of sentences for the survey evaluation, this script retreives the score of each answer
from stackapi import StackAPI
from statistics import median, mean
import pandas as pd
import csv

def read_sentence_data():
	answer_ids = []
	with open("../data/q10_ratingstatspure.csv", "r",) as file: 
		reader = csv.DictReader(file)
		for row in reader:
			answer_id = row['AnswerID'].split('-')[1]
			if answer_id not in answer_ids:
				answer_ids.append(answer_id)

	return answer_ids

def append_info(answer_info):
	full_answer_data = []
	with open("../data/q10_ratingstatspure.csv", "r",) as file: 
		sentence_data = pd.read_csv(file)
		sentence_data.insert(3,'Score',-400)
		#score_column = sentence_data['AnswerID'] + 1
		#accepted_column = score_column + 1
		#sentence_data['Score'] = score_column
		# sentence_data['Accepted'] = accepted_column
		for index, sentence in sentence_data.iterrows():
			for answer in answer_info:
				if sentence['AnswerID'].split('-')[1] == str(answer['answer_id']):
					#adjusting score
					sentence_data.set_value(index,'Score',answer['score'])
					break


		sentence_data.to_csv('../data/q10_answer_stats.csv', sep=',')

def query_so(answer_ids):
	SITE = StackAPI('stackoverflow', key='UuPf6s)HIuhohPoTj8Baww((')
	#, filter='!LH234MIo1JPc0dgsfp(Jm6'
	answers = SITE.fetch('answers', ids=answer_ids)
	items = answers.get('items')

	answer_dicts = []

	if items is not None:
		for answer in items:
			answer_dict = {}
			answer_dict['answer_id'] = answer['answer_id']
			answer_dict['score'] = answer['score']
			#answer_dict['accepted'] = answer['accepted']
			answer_dicts.append(answer_dict)

	return answer_dicts

def main():
	print("Reading sentence data")
	answer_ids = read_sentence_data()
	print(answer_ids)
	print("Querying SO")
	answer_info = query_so(answer_ids)
	print(answer_info)
	print("Appending files")
	append_info(answer_info)

if __name__ == '__main__':
    main()