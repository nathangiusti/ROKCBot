import praw
import datetime
import os

DATE_FORMAT = "%Y%m%d"
ARCHIVE_DIR = "heroku"
user_agent = "OkCupid Crush 2.0"


reddit = praw.Reddit(client_id='r6p0rrTKKtN-hw',
                     client_secret=os.environ['SECRET_KEY'] ,
                     user_agent=user_agent)

curr_date = datetime.date.fromordinal(datetime.date.today().toordinal())

comment_file = open("%s/Comment_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')
reply_file = open("%s/Reply_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')

for comment in reddit.subreddit('okcupid').stream.comments():
  if curr_date < datetime.date.today():
    curr_date = datetime.date.today()
    comment_file = open("%s/Comment_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')
    reply_file = open("%s/Reply_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')
  parent = comment.parent()
  comment_file.write(comment.author.name)
  comment_file.write("\n")
  print("Comment File: %s " % comment.author.name)
  if isinstance(parent, praw.models.Comment):
    parent.refresh()
    reply_file.write("%s,%s" %(parent.author.name, comment.author.name))
    reply_file.write("\n")
    print("Reply File: %s,%s" %(parent.author.name, comment.author.name))
