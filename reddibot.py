import praw
import time

comment_file = open("CommentCount.txt", 'w')
reply_file = open("ReplyCount.txt", 'w')

def generateStuff(comment, author):
  comment_file.write(comment.author.name)
  comment_file.write("\n")
  for reply in comment.replies:
    if reply.author is not None:
      reply_file.write("%s,%s" %(author, reply.author.name))
      reply_file.write("\n")
      generateStuff(reply, reply.author.name)

user_agent = ("OkCupid Crush 1.0")

r = praw.Reddit(user_agent = user_agent)

subreddit = r.get_subreddit("OkCupid")

i = 0
for submission in subreddit.get_new(limit = 1000):
  print "%s" % i
  i += 1
  submission.replace_more_comments(limit=None, threshold=0)
  for comment in submission.comments:
    if comment.author is not None:
      generateStuff(comment, comment.author.name)
