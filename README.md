# Inventário Proxmox VE
Este repositório contém um script inventario_proxmox_ve.sh para gerar inventario no Proxmox VE detalhado sobre o sistema Proxmox VE em uso. 

*ATENÇÃO: APENAS PARA PREGUIÇOSOS* KKKK

Seguem as instruções para download e uso do script.

1. Baixar o Arquivo
Para baixar o arquivo inventario_proxmox_ve.sh, você pode usar o curl ou o wget diretamente do terminal:

- Usando curl
```
curl -O https://raw.githubusercontent.com/lucastavarestga/proxmox-inventario-pve/main/inventario_proxmox_ve.sh
```

- Ou usando wget
```
wget https://raw.githubusercontent.com/lucastavarestga/proxmox-inventario-pve/main/inventario_proxmox_ve.sh
```

2. Definir Permissões
Setando as permissõs:

```
chmod +x inventario_proxmox_ve.sh
```

3. Executar o Script
Para executar o script, utilize o seguinte comando:

```
./inventario_proxmox_ve.sh
```

ou 

```
sh -x inventario_proxmox_ve.sh
```

4. Localização do Arquivo Gerado
O relatório gerado será salvo no mesmo diretório em que o script foi executado, com o seguinte formato de nome:

```
proxmox_documentation_pved_20250520_1602.txt
```

Agilizando a vida, baixando arquivo, setando permissão, executando :

```
cd /opt
rm inventario_proxmox_ve.sh
wget https://raw.githubusercontent.com/lucastavarestga/proxmox-inventario-pve/main/inventario_proxmox_ve.sh
chmod +x inventario_proxmox_ve.sh
sh -x inventario_proxmox_ve.sh
ls -lha proxmox_documentation*
```

5. Resumo
O relatório gerado incluirá:

Informações do sistema e do Proxmox VE
Informações sobre discos e armazenamento (incluindo configuração de LVM e ZFS)
Informações de rede
Detalhes sobre máquinas virtuais e containers LXC
Status dos serviços do Proxmox e informações de cluster
Informações de usuários e autenticação
Registro de auditoria e logs

Para qualquer dúvida ou contato, você pode me encontrar em 

### Qualquer dúvida, entre em contato.

<a href="mailto:lucastavarestga@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white" target="_blank"></a>
<a href="https://www.linkedin.com/in/lucastavarestga" target="_blank"><img src="https://img.shields.io/badge/-LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank"></a>
<a href="https://youtube.com/@lucastavaressoares" target="_blank"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" target="_blank"></a>

Youtube MasterMindTI

<a href="https://www.youtube.com/@mastermindti" target="_blank"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" target="_blank"></a>
