#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
sudo tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
    - name: Instalando o Python3, virtualenv
      apt:
        pkg:
          - python3
          - virtualenv
          - nodejs
        update_cache: true
      become: true
    - name: Git Clone
      git:
        repo: https://github.com/alura-cursos/clientes-leo-api.git
        dest: /home/ubuntu/myserver
        version: master
        force: yes
    - name: Instalando dependencias com o pip
      pip:
        virtualenv: /home/ubuntu/myserver/venv
        requirements: /home/ubuntu/myserver/requirements.txt
        state: present
    - name: Alterando hosts permitidos
      lineinfile:
        path: /home/ubuntu/myserver/setup/settings.py
        regexp: '^ALLOWED_HOSTS'
        line: 'ALLOWED_HOSTS = ["*"]'
        backrefs: true
    - name: Configurando base de dados
      shell: |
        cd /home/ubuntu/myserver
        . venv/bin/activate
        python manage.py migrate
    - name: Carregando dados
      shell: |
        cd /home/ubuntu/myserver
        . venv/bin/activate
        python manage.py loaddata clientes.json
    - name: Iniciando Server
      shell: |
        . /home/ubuntu/myserver/venv/bin/activate
        nohup python /home/ubuntu/myserver/manage.py runserver 0.0.0.0:8000 > logs.out &
    - name: Finalizando
      debug:
        msg: "Finalizado"
EOT
sudo ansible-playbook playbook.yml