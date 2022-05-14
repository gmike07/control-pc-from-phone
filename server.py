try:
    import argparse
    import socket
    import websockets
    from requests import get
    import qrcode
    from threading import Thread
    from zlib import compress
    from mss import mss
    import asyncio
    import pyautogui
    import upnpy
    import time
    import threading
    import math
except: # to install packages and restart if needed
    import os, sys
    os.system('pip install socket')
    os.system('pip install websockets')
    os.system('pip install qrcode')
    os.system('pip install zlib')
    os.system('pip install mss')
    os.system('pip install asyncio')
    os.system('pip install pyautogui')
    os.system('pip install upnpy')
    os.startfile(sys.argv[0])
    sys.exit()


pyautogui.FAILSAFE = False

class Mapping:
    def __init__(self):
        self.SCROLL_SPEED = 150
        self.SPEED_MOUSE = 100
        self.distance = 0
        self.angle = 0

    def move_mouse(self, angle, distance):
        self.angle = angle / 180 * math.pi
        self.distance = distance

    def scroll_mouse(self, angle, distance):
        angle = angle / 180 * math.pi
        print(angle, distance)
        pyautogui.scroll(int(-self.SCROLL_SPEED * distance * math.sin(angle)))
        pyautogui.hscroll(int(self.SCROLL_SPEED * distance * math.cos(angle)))

    def update_mouse(self):
        pyautogui.moveRel(self.SPEED_MOUSE * math.sin(self.angle) * self.distance,
                          -self.SPEED_MOUSE * math.cos(self.angle) * self.distance)

    def __getitem__(self, item):
        mapping_dct = {'mouse_move': self.move_mouse,
                       'keyboard_press': pyautogui.write,
                       'scroll_up': lambda: pyautogui.scroll(10),
                       'scroll_down': lambda: pyautogui.scroll(-10),
                       'scroll_left': lambda: pyautogui.hscroll(10),
                       'scroll_right': lambda: pyautogui.hscroll(-10),
                       'scroll': self.scroll_mouse,
                       'click': pyautogui.click,
                       'double_click': pyautogui.doubleClick,
                       'right_click': pyautogui.rightClick,
                       'enter': lambda: pyautogui.press('enter'),
                       'erase': lambda: pyautogui.press('backspace')}
        return mapping_dct[item]

def create_QR_from_string(qr_msg, filename='', save_image=False, show_image=True):
    qr = qrcode.QRCode(version=1, box_size=15, border=5)
    qr.add_data(qr_msg)
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white')
    if save_image:
        img.save(filename)
    if show_image:
        img.show()


def prepare_server_with_ip(type, port):
    if type == 'LAN':
        # stack overflow
        ip = [l for l in ([[(s.connect(('8.8.8.8', 53)), s.getsockname()[0],
                             s.close()) for s in
                            [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][
                               0][1]], [ip for ip in socket.gethostbyname_ex(
            socket.gethostname())[2] if not ip.startswith("127.")][:1]) if l][
            0][0]
    else:
        # stack overflow
        ip = get('https://api.ipify.org').text
        # TODO: check that binding ip works
        print('for this to work you need to enable port forwarding on your router')
        upnp = upnpy.UPnP()
        device = upnp.get_igd()
        service = device['WANPPPConnection.1']
        service.AddPortMapping(
            NewRemoteHost='',
            NewExternalPort=port,
            NewProtocol='TCP',
            NewInternalPort=port,
            NewInternalClient=socket.gethostbyname(socket.gethostname()),
            NewEnabled=1,
            NewPortMappingDescription='Test port mapping entry from UPnPy.',
            NewLeaseDuration=0
        )
    return ip

# [120, 112, 101], []
def parse_input(s):
    string = ''
    while s.find(']') != -1:
        i = s.find(']')
        string += ''.join(chr(int(element)) for element in s[1:i].split(', ') if element != '')
        s = s[i+1:]
    return string, s

def listen_client(conn):
    instuctor = Mapping()
    string = ''
    while 'receiving msgs':
        string += conn.recv(4096).decode('utf-8')
        s, string = parse_input(string)
        instructions = s.split('\n')
        for instruction in instructions:
            if instruction == '':
                continue
            if instruction.startswith('keyboard_press'):
                instuctor['keyboard_press'](instruction[len('keyboard_press:'):])
            elif instruction.startswith('mouse_move'):
                instruction = instruction[len('mouse_move:'):].split(',')
                angle, dist = float(instruction[0]), float(instruction[1])
                instuctor['mouse_move'](angle, dist)
            elif instruction.startswith('scroll'):
                instruction = instruction[len('scroll:'):].split(',')
                angle, dist = float(instruction[0]), float(instruction[1])
                instuctor['scroll'](angle, dist)
            else:
                instuctor[instruction]()
        instuctor.update_mouse()


    conn.close()


def main_server():
    port = 8000
    ip = prepare_server_with_ip('LAN', port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print((ip, port))
    sock.bind((ip, port))
    create_QR_from_string(f'{ip} {port}')
    sock.listen(5)
    while 'connected':
        conn, addr = sock.accept()
        print('connected')
        t = threading.Thread(target=listen_client, args=(conn,))
        t.start()


if __name__ == '__main__':
    main_server()
