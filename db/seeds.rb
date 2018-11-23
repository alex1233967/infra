# encoding: UTF-8
Phone.delete_all
Phone.create(name: "Отключено", phone_number: 0, branch: 0)

Session.delete_all
Session.create(name: "admin", password: "changeme", allowed_phones: "170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185", admin: true, callforwarder: true, infravisor: true)
