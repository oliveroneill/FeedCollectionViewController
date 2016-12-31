import os
import time
import shutil
import tinys3

if __name__ == '__main__':
    filename = 'failures_{}'.format(time.time())
    failureDir = 'FailureDiffs/'
    if os.path.isdir(failureDir):
        shutil.make_archive(filename, 'zip', failureDir)
        filename += '.zip'

        conn = tinys3.Connection(os.environ['AWS_ACCESS_KEY_ID'],os.environ['AWS_SECRET_ACCESS_KEY'],tls=True)
        with open(filename,'rb') as f:
            conn.upload(filename,f,os.environ['UPLOAD_IOS_SNAPSHOT_BUCKET_NAME'])
    else:
        print("No failures found")
