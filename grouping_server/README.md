# grouping_server
grouping application backend server which uses Python Django framework

## Environment setting
* 建立虛擬環境
* 讀取 requirements.txt 建立虛擬環境
* 執行 server

## 建立虛擬環境
```bash
pip3 install python3-venv
```

### Step 1 — create venv

```bash
$ python3 -m venv <your_venv_name>
```

### Step 2 — active your venv

```bash
$ source <your_venv_name>/bin/activate
```

### Step 3 — exit
```bash
$ deactivate
```
### 使用 requirements.txt

- 導出 requirements.txt

```bash
$ pip freeze > requirements.txt
```

- pip 安裝 requirements.txt 指定套件

 

```bash
$ pip install -r requirements.txt
```
