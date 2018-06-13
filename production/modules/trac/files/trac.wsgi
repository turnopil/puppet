import os

#os.environ['TRAC_PARENT_ENV'] = '/var/trac'
os.environ['TRAC_ENV'] = '/var/trac/trac_projects/svn'
os.environ['PYTHON_EGG_CACHE'] = '/tmp'

import trac.web.main
application = trac.web.main.dispatch_request