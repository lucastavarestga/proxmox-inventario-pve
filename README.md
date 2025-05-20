# Inventário Proxmox VE
Este repositório contém um script inventario_proxmox_ve.sh para gerar investario no Proxmox VE detalhado sobre o sistema Proxmox VE em uso. 

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

e-mail: lucastavarestga@gmail.com
### [Linkedin lucastavarestga](https://www.linkedin.com/in/lucastavarestga)

Versão: 1.4.1

Data de Lançamento: Maio/2025

Elaborado por: Lucas Tavares Soares

Espero ter ajudado em algo, um grande abraço.
