import pymysql
import csv

def write_to_csv(filename, data):
	fp = open(filename, 'w')
	myFile = csv.writer(fp)
	myFile.writerows(data)
	fp.close()

def write_to_csv_with_count(filename, rows):
	fp = open(filename, 'w')
	csvwriter = csv.writer(fp)
	if rows:
		for row in rows:
			new_row = (row[0], row[1].decode())
			csvwriter.writerow(new_row)
	
	fp.close()

def get_sentences_to_analyze(question, level):
	with open('../data/' + question + '_' + level + '_rated_sentence_ids.txt', 'r') as id_file:
		sentence_ids = id_file.read()

	query = 'select \'SentenceID\', \'Technique\', \'SentenceText\' UNION ALL select id, technique, sentence_text from sentences where id in ' + sentence_ids
	cursor.execute(query)
	rows = cursor.fetchall()
	write_to_csv('../data/q' + str(q_id) + '.csv', rows)
	write_to_csv('../data/' + question + '_' + level + '_rated_sentences.csv', rows)

#writes output but breaks down the mapping of techniques
#https://stackoverflow.com/questions/4613465/using-python-to-write-mysql-query-to-csv-need-to-show-field-names by Mathnode
# 1: ifsentence
# 2: condinsight
# 3: WordPatternBaseline
# 4: ifsentence-WordPatternBaseline (1 + 3)
# 5: condinsight-WordPatternBaseline (2 + 3)
# 6: lexrank
# 7: ifsentence + lexrank (1 + 6)
# 8: condinsight + lexrank (2 + 6)
# 9: wordpattern + lexrank (3 + 6)
# 10: ifsentence + wordpatternbaseline + lexrank (1 + 3 + 6)
def write_techniques(filename, rows):
	# Continue only if there are rows returned.
	if rows:
		# New empty list called 'result'. This will be written to a file.
		result = list()

		for row in rows:
			if row[1] == "2":#all condinsight sentences are also ifsentences
				result.append(row)
				new_row = (row[0], "1", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "4":
				new_row = (row[0], "1", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "3", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "5":
				new_row = (row[0], "1", row[2], row[3], row[4])#all condinsight sentences are also ifsentences
				result.append(new_row)
				new_row = (row[0], "2", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "3", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "7":
				new_row = (row[0], "1", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "6", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "8":
				new_row = (row[0], "1", row[2], row[3], row[4])#all condinsight sentences are also ifsentences
				result.append(new_row)
				new_row = (row[0], "2", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "6", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "9":
				new_row = (row[0], "3", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "6", row[2], row[3], row[4])
				result.append(new_row)
			elif row[1] == "10":
				new_row = (row[0], "1", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "3", row[2], row[3], row[4])
				result.append(new_row)
				new_row = (row[0], "6", row[2], row[3], row[4])
				result.append(new_row)
			else:
				result.append(row)

		# Write result to file.
		with open(filename, 'w', newline='') as csvfile:
			csvwriter = csv.writer(csvfile)
			for row in result:
				csvwriter.writerow(row)
	else:
		sys.exit("No rows found for query: {}".format(sql))

#writes output but breaks down the mapping of techniques but for 3 col data..
#TODO: join with prev function to avoid duplication
#https://stackoverflow.com/questions/4613465/using-python-to-write-mysql-query-to-csv-need-to-show-field-names by Mathnode
# 1: ifsentence
# 2: condinsight
# 3: WordPatternBaseline
# 4: ifsentence-WordPatternBaseline (1 + 3)
# 5: condinsight-WordPatternBaseline (2 + 3)
# 6: lexrank
# 7: ifsentence + lexrank (1 + 6)
# 8: condinsight + lexrank (2 + 6)
# 9: wordpattern + lexrank (3 + 6)
# 10: ifsentence + wordpatternbaseline + lexrank (1 + 3 + 6)
def write_techniques_threecols(filename, rows):
	# Continue only if there are rows returned.
	if rows:
		# New empty list called 'result'. This will be written to a file.
		result = list()

		for row in rows:
			if row[1] == "2":#all condinsight sentences are also ifsentences
				new_row = (row[0], row[1], row[2].decode())
				result.append(new_row)
				new_row = (row[0], "1", row[2].decode())
				result.append(new_row)
			elif row[1] == "4":
				new_row = (row[0], "1", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "3", row[2].decode())
				result.append(new_row)
			elif row[1] == "5":
				new_row = (row[0], "1", row[2].decode())#all condinsight sentences are also ifsentences
				result.append(new_row)
				new_row = (row[0], "2", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "3", row[2].decode())
				result.append(new_row)
			elif row[1] == "7":
				new_row = (row[0], "1", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "6", row[2].decode())
				result.append(new_row)
			elif row[1] == "8":
				new_row = (row[0], "1", row[2].decode())#all condinsight sentences are also ifsentences
				result.append(new_row)
				new_row = (row[0], "2", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "6", row[2].decode())
				result.append(new_row)
			elif row[1] == "9":
				new_row = (row[0], "3", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "6", row[2].decode())
				result.append(new_row)
			elif row[1] == "10":
				new_row = (row[0], "1", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "3", row[2].decode())
				result.append(new_row)
				new_row = (row[0], "6", row[2].decode())
				result.append(new_row)
			else:
				new_row = (row[0], row[1], row[2].decode())
				result.append(new_row)

		# Write result to file.
		with open(filename, 'w', newline='') as csvfile:
			csvwriter = csv.writer(csvfile)
			for row in result:
				csvwriter.writerow(row)
	else:
		sys.exit("No rows found for query: {}".format(sql))

def create_filtered_ids(result):
	with open('../data/ids_filtered.txt', 'w', newline='') as file:
		file.write('(')
		size = len(result)
		index = 0
		for row in result:
			file.write('\'' + row[0] +  '\'')
			if index != size - 1:
				file.write(',\n')
			index += 1
		file.write(')')

	with open('../data/ids_filtered.txt', 'r') as file:
		survey_user_ids = file.read()
		return survey_user_ids


with open('../data/ids.txt', 'r') as id_file:
    survey_user_ids = id_file.read()

connection = pymysql.connect(user="root",db="db")

try:
	with connection.cursor() as cursor:

		##Get original number of users
		query = 'select count(DISTINCT user_id) from responses where user_id in ' + survey_user_ids 
		cursor.execute(query);
		original_size = cursor.fetchone()[0]
		print ("\\pgfkeyssetvalue{{original_participants}}{{{}}}".format(original_size))

		##Filter out users who thought our negative quality sentence was useful
		#response = \'Neither agree or disagree\'
		query = 'select user_id from responses where sentence_id = -1 and question_id=10 and (response = \'Disagree\' or response=\'Strongly disagree\') and user_id in ' + survey_user_ids
		cursor.execute(query);
		survey_user_ids = cursor.fetchall()
		new_size = len(survey_user_ids)
		survey_user_ids = create_filtered_ids(survey_user_ids) #new user ids with only participants who thought the negative quality sentence was not useful
		print ("\\pgfkeyssetvalue{{filtered_out_participants}}{{{}}}".format(original_size - new_size))
		print ("\\pgfkeyssetvalue{{final_num_participants}}{{{}}}".format(new_size))

		##Get total threads evaluated
		query = 'select thread_id, count(DISTINCT user_id)  from responses, sentences, questions where responses.sentence_id = sentences.id and responses.question_id = questions.id and questions.qtype = \'sg\' and sentence_id > 0 and user_id in ' + survey_user_ids + ' group by thread_id' 
		cursor.execute(query)

		query = 'select count(DISTINCT thread_id) from responses, sentences where responses.sentence_id = sentences.id and sentence_id > 0 and user_id in ' + survey_user_ids
		cursor.execute(query)

		print ("\\pgfkeyssetvalue{{total_threads_eval}}{{{}}}".format(cursor.fetchone()[0]))

		query = 'select count(DISTINCT sentence_id) from responses where sentence_id > 0 and user_id in ' + survey_user_ids
		cursor.execute(query)

		print ("\\pgfkeyssetvalue{{total_sentence_eval}}{{{}}}".format(cursor.fetchone()[0]))

		##Get total number of sentences in each technique
		# 1: ifsentence
		# 2: condinsight
		# 3: WordPatternBaseline
		# 4: ifsentence-WordPatternBaseline (1 + 3)
		# 5: condinsight-WordPatternBaseline (2 + 3)
		# 6: lexrank
		# 7: ifsentence + lexrank (1 + 6)
		# 8: condinsight + lexrank (2 + 6)
		# 9: wordpattern + lexrank (3 + 6)
		# 10: ifsentence + wordpatternbaseline + lexrank (1 + 3 + 6)
		query = 'select count(distinct id) from sentences where (technique = 1 or technique = 2 or technique = 4 or technique = 5 or technique = 8 or technique = 7 or technique=10)'
		cursor.execute(query);
		print ("\\pgfkeyssetvalue{{number_simpleif_sentences}}{{{}}}".format(cursor.fetchone()[0]))

		query = 'select count(distinct id) from sentences where (technique = 2 or technique = 5 or technique = 8)'
		cursor.execute(query);
		print ("\\pgfkeyssetvalue{{number_condinsight_sentences}}{{{}}}".format(cursor.fetchone()[0]))

		query = 'select count(distinct id) from sentences where (technique = 3 or technique = 4 or technique = 5 or technique = 9 or technique = 10)'
		cursor.execute(query);
		print ("\\pgfkeyssetvalue{{number_wordpattern_sentences}}{{{}}}".format(cursor.fetchone()[0]))

		query = 'select count(distinct id) from sentences where (technique >= 6)'
		cursor.execute(query);
		print ("\\pgfkeyssetvalue{{number_lexrank_sentences}}{{{}}}".format(cursor.fetchone()[0]))

		##dump answers to bg questions to be processed in R
		#https://stackoverflow.com/questions/4613465/using-python-to-write-mysql-query-to-csv-need-to-show-field-names
		for q_id in range(1,8):
			query = 'select \'UserId\', \'Response\' Union ALL select user_id, response from responses where question_id = ' + str(q_id) +' and user_id in'  + survey_user_ids
			cursor.execute(query)
			rows = cursor.fetchall()
			write_to_csv('../data/q' + str(q_id) + '.csv', rows)

		##dump answers of sentence questions to be processed in R
		for q_id in range(8,11):
			query = 'select \'SentenceID\', \'Technique\',  \'SentenceText\', \'User_ID\', \'Response\' UNION ALL select sentence_id, technique, sentence_text, user_id, response from responses, sentences where responses.sentence_id = sentences.id and sentence_id > 0 and question_id =' + str(q_id) +' and user_id in ' + survey_user_ids
			cursor.execute(query)
			rows = cursor.fetchall()
			write_techniques('../data/q' + str(q_id) + '.csv', rows)
			#write_to_csv('../data/q' + str(q_id) + '.csv', rows)

		##dump number of ratings per thread
		##just using question 8 here but any question would do or doing distinct
		query = 'select \'ThreadID\', \'Count\' UNION ALL select  thread_id, count(DISTINCT user_id)  from sentences, responses  where sentences.id = responses.sentence_id  and sentence_id > 0 and question_id=8 and user_id in ' + survey_user_ids + ' group by thread_id'
		cursor.execute(query)
		rows = cursor.fetchall()
		write_to_csv_with_count('../data/rating_per_thread.csv', rows)

		##dump number of sentences evaluated for each technique
		##just using question 8 here but any question would do or doing distinct
		query = 'select \'SentenceID\', \'Technique\', \'Count\' UNION ALL select sentence_id, technique, count(*) from sentences, responses  where sentences.id = responses.sentence_id and sentence_id > 0 and question_id=8 and user_id in ' + survey_user_ids + ' group by technique, sentence_id'
		cursor.execute(query)
		rows = cursor.fetchall()
		write_techniques_threecols('../data/rating_per_sentence_per_technique.csv', rows)

		##dump exit answers
		for q_id in range(11,18):
			query = 'select \'ResponseID\', \'User_ID\', \'SentenceID\', \'SentenceText\', \'Response\' UNION ALL select responses.id, user_id, sentence_id, sentence_text, response from responses, sentences where responses.sentence_id=sentences.id and question_id =' + str(q_id) +' and user_id in ' + survey_user_ids
			cursor.execute(query)
			rows = cursor.fetchall()
			write_to_csv('../data/q' + str(q_id) + '.csv', rows)
			#write_to_csv('../data/q' + str(q_id) + '.csv', rows)

		##get sentence text for interesting sentences
		##ids created manually based on analyzing plots
		# get_sentences_to_analyze('q9', 'high')
		# get_sentences_to_analyze('q9', 'low')
		# get_sentences_to_analyze('q10', 'high')
		# get_sentences_to_analyze('q10', 'low')

finally: 
	connection.close()