from datetime import datetime
from aiosmtpd.controller import Controller
from aiosmtpd.handlers import AsyncMessage
import asyncio

class EmlHandler(AsyncMessage):
    no = 0

    async def handle_message(self, message):
        filename = '%s-%d.eml' % (datetime.now().strftime('%Y%m%d%H%M%S'), self.no)
        with open(filename, 'wb') as f:
            f.write(message.as_bytes())
        print('%s saved.' % filename)
        self.no += 1

def run():
    controller = Controller(EmlHandler(), hostname='0.0.0.0', port=10025)
    controller.start()
    print("SMTP server running on port 10025...")
    try:
        asyncio.get_event_loop().run_forever()
    except KeyboardInterrupt:
        controller.stop()


if __name__ == '__main__':
    run()
