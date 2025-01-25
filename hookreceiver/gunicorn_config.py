# Gunicorn configuration file
import multiprocessing

# Server socket
bind = 'localhost:8000'
backlog = 2048

# Worker processes
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = 'sync'  # other options: gevent, eventlet, tornado
worker_connections = 100
timeout = 30
keepalive = 2

# Process naming
proc_name = 'hookreceiver'

# Logging
accesslog = 'access.log'
errorlog = 'error.log'
loglevel = 'info'

# Environment variables (optional)
raw_env = [
    'WEBHOOK_SECRET=your-secret-here',
    'DB_NAME=hooks.db',
    'STATUS_CODE=200'
] 