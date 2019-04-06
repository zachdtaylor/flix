from os import walk

graphql_folder_path = './graphql/'
files = []
for (dirpath, _, filenames) in walk(graphql_folder_path):
  files.extend([ (filename[0:len(filename)-4], (dirpath + '/' + filename)[2::]) for filename in filenames])

file_contents = "// GraphQL Constants for Queries and Mutations\n\n"
for (name, path) in files:
  operation = 'Q' if 'queries' in path else 'M'
  line = "const String GQL_{}_{} = '{}';\n\n".format(operation, name.upper(), path)
  file_contents += line

file = open('./lib/util/graphql/graphql_constants.dart', 'w')
file.write(file_contents)
file.close()
