#!/bin/bash
# Define o nome do arquivo de saída
HOSTNAME=$(hostname -s) # Usando -s para hostname curto, mais comum em nomes de arquivo
DATE=$(date +"%Y%m%d_%H%M") # Formato de data sem espaços para nome de arquivo
OUTPUT_FILE="proxmox_documentation_${HOSTNAME}_${DATE}.txt"

echo "As informações serão salvas em: $OUTPUT_FILE"

# As mensagens iniciais também vão para o arquivo
echo "===================================================" >> $OUTPUT_FILE
echo "-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-" >> $OUTPUT_FILE
echo "Elaborado por: Lucas Tavares Soares" >> $OUTPUT_FILE
echo "Contato: lucas@fkmais.com.br" >> $OUTPUT_FILE
echo "Linkedin https://www.linkedin.com/in/lucastavarestga/  >> $OUTPUT_FILE
echo "Versao: 1.4.3" >> $OUTPUT_FILE
echo "Maio/2025" >> $OUTPUT_FILE
echo "-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "DOCUMENTAÇÃO DO HOST PROXMOX VE - $(hostname -f)" >> $OUTPUT_FILE # Usando -f para hostname completo
echo "Data da Geração: $(date +"%Y-%m-%d %H:%M:%S")" >> $OUTPUT_FILE
#echo "Data da Geração: $(date +%Y-%m-%d %H:%M:%S)" >> $OUTPUT_FILE
echo "===================================================" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "### 1. INFORMAÇÕES DO SISTEMA E PROXMOX ###" >> $OUTPUT_FILE
echo "------------------------------------------" >> $OUTPUT_FILE
echo "Versão do Proxmox VE:" >> $OUTPUT_FILE
pveversion >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Versão do Kernel:" >> $OUTPUT_FILE
uname -a >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Uptime do Sistema:" >> $OUTPUT_FILE
uptime >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Usuarios logados:" >> $OUTPUT_FILE
who >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "hostnamectl:" >> $OUTPUT_FILE
hostnamectl >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Informacoes adicionais do Sistema" >> $OUTPUT_FILE
dmidecode -t system >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Informações da CPU:" >> $OUTPUT_FILE
lscpu >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Informações da Memória:" >> $OUTPUT_FILE
free -h >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 2. INFORMAÇÕES DE DISCO E ARMAZENAMENTO ###" >> $OUTPUT_FILE
echo "-----------------------------------------------" >> $OUTPUT_FILE
echo "Discos Físicos (lsblk):" >> $OUTPUT_FILE
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,ROTA,TYPE,MODEL >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Uso de Disco (df -hT):" >> $OUTPUT_FILE
df -hT >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configuração de Armazenamento Proxmox (pvesm status):" >> $OUTPUT_FILE
pvesm status >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Detalhes de Armazenamento Proxmox (cat /etc/pve/storage.cfg):" >> $OUTPUT_FILE
cat /etc/pve/storage.cfg >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Informações de LVM:" >> $OUTPUT_FILE
if command -v vgs &> /dev/null; then
    echo "  Volume Groups (vgs):" >> $OUTPUT_FILE
    vgs -o +tags >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE

    echo "  Detalhes dos Volume Groups (vgdisplay):" >> $OUTPUT_FILE
    vgdisplay >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE

    echo "  Logical Volumes (lvs):" >> $OUTPUT_FILE
    # lvs sem opções extras é bom, mas se quiser detalhes como LV UUID, use 'lvs -o +lv_uuid'
    lvs >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE

    echo "  Detalhes dos Logical Volumes (lvdisplay):" >> $OUTPUT_FILE
    lvdisplay >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
    
    echo "  Exibir volumes físicos (pvdisplay):" >> $OUTPUT_FILE
    pvdisplay >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
else
    echo "  Comandos LVM (vgs, lvs, vgdisplay, lvdisplay) não encontrados. LVM pode não estar sendo utilizado ou instalado neste host." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "Informações de ZFS:" >> "$OUTPUT_FILE"
echo "ZFS Pools:" >> "$OUTPUT_FILE"

if ! command -v zpool >/dev/null 2>&1; then
    echo "  pool de armazenamento não encontrado no sistema." >> "$OUTPUT_FILE"
else
    # Verifica se há pools listados (ignorando a linha de cabeçalho)
    if zpool list -H >/dev/null 2>&1; then
        echo "  Listar todos os pools do ZFS (zpool list):" >> "$OUTPUT_FILE"
        zpool list >> "$OUTPUT_FILE" 2>&1
        echo " " >> "$OUTPUT_FILE"

        echo "  Mostrar status detalhado e saúde do pool (zpool status -v):" >> "$OUTPUT_FILE"
        zpool status -v >> "$OUTPUT_FILE" 2>&1
        echo " " >> "$OUTPUT_FILE"

        echo "  Mostrar todas as propriedades de uma pool (zpool get all):" >> "$OUTPUT_FILE"
        zpool get all >> "$OUTPUT_FILE" 2>&1
        echo " " >> "$OUTPUT_FILE"
    else
        echo "  Nenhum pool ZFS disponível." >> "$OUTPUT_FILE"
    fi
fi
echo "" >> "$OUTPUT_FILE"

echo "Informações ZFS Filesystem:" >> "$OUTPUT_FILE"

if ! command -v zfs >/dev/null 2>&1; then
    echo "  pool de armazenamento não encontrado no sistema." >> "$OUTPUT_FILE"
else
    # Executa zfs list e verifica a saída
    if zfs list 2>&1 | grep -q "no datasets available"; then
        echo "  pool de armazenamento não encontrado no sistema." >> "$OUTPUT_FILE"
    else
        echo "  Listar todos os datasets ZFS (zfs list):" >> "$OUTPUT_FILE"
        zfs list >> "$OUTPUT_FILE" 2>&1
        echo " " >> "$OUTPUT_FILE"
    fi
fi
echo "" >> "$OUTPUT_FILE"

echo "Montagens de Sistema de Arquivos (/etc/fstab e mount):" >> $OUTPUT_FILE
echo "  Configuração de Montagens Fixas (/etc/fstab):" >> $OUTPUT_FILE
cat /etc/fstab >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "  Montagens Ativas (mount):" >> $OUTPUT_FILE
# O '-l' não é necessário e o '-t' já filtra pelos tipos, assim o comando fica mais limpo e focado.
mount -t ext4,xfs,zfs,nfs,cifs,tmpfs,fuse.lxcfs >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 3. INFORMAÇÕES DE REDE ###" >> $OUTPUT_FILE
echo "------------------------------" >> $OUTPUT_FILE

echo "IP Externo atual:" >> $OUTPUT_FILE
curl ifconfig.me >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Exibir todas informacoes do ip externo, como ip, hostname, cidade, regiao operadora: " >> $OUTPUT_FILE 
curl ipinfo.io >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configuração de Interfaces de Rede (ip a):" >> $OUTPUT_FILE
ip a >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configuração de Interfaces (ip -br -c a, filtrado):" >> $OUTPUT_FILE
# Correção do pipe para o grep, garantindo que egrep seja usado
ip -br -c a | egrep -v 'fwbr|fwln|tap' >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configuração de Bridge Proxmox (cat /etc/network/interfaces):" >> $OUTPUT_FILE
cat /etc/network/interfaces >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Rotas de Rede (ip r):" >> $OUTPUT_FILE
ip r >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Servidores DNS (/etc/resolv.conf):" >> $OUTPUT_FILE
cat /etc/resolv.conf >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Status das Portas de Rede (ss -tulnp):" >> $OUTPUT_FILE
ss -tulnp >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 4. INFORMAÇÕES DE MÁQUINAS VIRTUAIS E CONTAINERS LXC ###" >> $OUTPUT_FILE
echo "------------------------------------------------------------" >> $OUTPUT_FILE
echo "Lista de Todas as Máquinas Virtuais (qm list):" >> $OUTPUT_FILE
qm list >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Lista de Todos os Containers LXC (pct list):" >> $OUTPUT_FILE
pct list >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Máquinas Virtuais em Execução:" >> $OUTPUT_FILE
qm list | grep "running" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Containers LXC em Execução:" >> $OUTPUT_FILE
pct list | grep "running" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Máquinas Virtuais Desligadas:" >> $OUTPUT_FILE
qm list | grep "stopped" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Containers LXC Desligados:" >> $OUTPUT_FILE
pct list | grep "stopped" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configuracoes Completas de Pools, VMs, Containers e Storages :" >> $OUTPUT_FILE
pvesh get /cluster/resources >> $OUTPUT_FILE 
echo "" >> $OUTPUT_FILE

#echo "Configurações de Máquinas Virtuais (Exemplo: Vmid 100, para todas qm config <vmid>):" >> $OUTPUT_FILE
#echo "Para ver as configurações detalhadas de cada VM, execute 'qm config <VMID>'." >> $OUTPUT_FILE
#echo "" >> $OUTPUT_FILE

#echo "Configurações de Containers LXC (Exemplo: CTID 101, para todos pct config <ctid>):" >> $OUTPUT_FILE
#echo "Para ver as configurações detalhadas de cada CT, execute 'pct config <CTID>'." >> $OUTPUT_FILE
#echo "" >> $OUTPUT_FILE

echo "Backups Agendados do Proxmox VE (cat /etc/pve/vzdump.conf):" >> $OUTPUT_FILE
if [ -f "/etc/pve/vzdump.conf" ]; then
    cat /etc/pve/vzdump.conf >> $OUTPUT_FILE
else
    echo "  Arquivo /etc/pve/vzdump.conf não encontrado. Nenhum backup agendado pode estar configurado." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "Configurações de notificações por e-mail do Proxmox VE (cat /etc/pve/notifications.cfg):" >> $OUTPUT_FILE
if [ -f "/etc/pve/notifications.cfg" ]; then
    cat /etc/pve/notifications.cfg >> $OUTPUT_FILE
else
    echo "  Arquivo /etc/pve/notifications.cfg não encontrado. Nenhuma notificação por email configurada de forma personalizada." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 5. STATUS DOS SERVIÇOS PROXMOX ###" >> $OUTPUT_FILE
echo "------------------------------------" >> $OUTPUT_FILE
echo "Status dos Serviços Proxmox (systemctl status pve-cluster pveproxy pvedaemon pvestatd):" >> $OUTPUT_FILE
systemctl status pve-cluster pveproxy pvedaemon pvestatd >> $OUTPUT_FILE 2>&1
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 6. INFORMAÇÕES DE CLUSTER PROXMOX E HA ###" >> $OUTPUT_FILE
echo "---------------------------------------------" >> $OUTPUT_FILE
echo "Informações de Cluster Proxmox:" >> $OUTPUT_FILE
if [ -f /etc/pve/corosync.conf ]; then
    echo "  Este host faz parte de um cluster Proxmox." >> $OUTPUT_FILE
    echo "  Conteúdo de /etc/pve/corosync.conf:" >> $OUTPUT_FILE
    cat /etc/pve/corosync.conf >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
    echo "  Status do Cluster (pvecm status):" >> $OUTPUT_FILE
    pvecm status >> $OUTPUT_FILE 2>&1
else
    echo "  Este host não parece fazer parte de um cluster Proxmox (arquivo /etc/pve/corosync.conf não encontrado)." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "Informações sobre MultiPath (se configurado - multipath -ll):" >> $OUTPUT_FILE
if command -v multipath &> /dev/null; then
    multipath -ll >> $OUTPUT_FILE 2>&1
else
    echo "  Comando multipath não encontrado. Multipathing pode não estar instalado ou configurado." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "Configuração de Alta Disponibilidade (HA):" >> $OUTPUT_FILE
echo "  Status do HA (ha-manager status):" >> $OUTPUT_FILE
if command -v ha-manager &> /dev/null; then
    ha-manager status >> $OUTPUT_FILE 2>&1
else
    echo "  Comando ha-manager não encontrado ou HA não configurado." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "  Recursos HA configurados (buscando em qm/pct configs):" >> $OUTPUT_FILE
# Verifica se há algo para grep, caso contrário, imprime a mensagem de "nenhum recurso"
if grep -q -rE 'ha:|ha_restart_on_boot:' /etc/pve/qemu-server/ /etc/pve/lxc/ 2>/dev/null; then
    grep -rE 'ha:|ha_restart_on_boot:' /etc/pve/qemu-server/ /etc/pve/lxc/ >> $OUTPUT_FILE
else
    echo "  Nenhum recurso de HA explicitamente configurado nos arquivos de VM/CT." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 7. INFORMAÇÕES DE USUÁRIOS E AUTENTICAÇÃO ###" >> $OUTPUT_FILE
echo "-----------------------------------------------" >> $OUTPUT_FILE
echo "Usuários do Sistema (/etc/passwd - primeiros 100):" >> $OUTPUT_FILE
head -n 100 /etc/passwd >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Grupos do Sistema (/etc/group - primeiros 100):" >> $OUTPUT_FILE
head -n 100 /etc/group >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Usuários do Proxmox VE (pveum user list):" >> $OUTPUT_FILE
pveum user list >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Grupos do Proxmox VE (pveum group list):" >> $OUTPUT_FILE
pveum group list >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Configurações de Autenticação Proxmox (cat /etc/pve/user.cfg):" >> $OUTPUT_FILE
cat /etc/pve/user.cfg >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Listando ACLs personalizadas (pveum acl list):" >> $OUTPUT_FILE
pveum acl list >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE


echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 8. INFORMAÇÕES DE AUDITORIA E LOGS ###" >> $OUTPUT_FILE
echo "-----------------------------------------" >> $OUTPUT_FILE
echo "Lista dos 100 Últimos Pacotes Instalados (dpkg.log):" >> $OUTPUT_FILE
if [ -f /var/log/dpkg.log ]; then
    tail -n 100 /var/log/dpkg.log | grep ' install ' >> $OUTPUT_FILE
else
    echo "  Arquivo /var/log/dpkg.log não encontrado." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "Repositórios APT configurados (/etc/apt/sources.list e /etc/apt/sources.list.d/):" >> $OUTPUT_FILE
cat /etc/apt/sources.list >> $OUTPUT_FILE
echo "--- Conteúdo de /etc/apt/sources.list.d/ ---" >> $OUTPUT_FILE
ls -l /etc/apt/sources.list.d/ >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Loop pelos arquivos .list em sources.list.d para incluir todos eles
for f in /etc/apt/sources.list.d/*.list; do
    if [ -f "$f" ]; then
        echo "  Conteúdo de $f:" >> $OUTPUT_FILE
        cat "$f" >> $OUTPUT_FILE
        echo "" >> $OUTPUT_FILE
    fi
done
echo "" >> $OUTPUT_FILE

echo "---------------------------------------------------" >> $OUTPUT_FILE

echo "### 9. AGENDAMENTOS E SERVIÇOS ###" >> $OUTPUT_FILE
echo "---------------------------------" >> $OUTPUT_FILE
echo "Crontab do Usuário root (crontab -l):" >> $OUTPUT_FILE
# Verifica se o crontab -l tem saída (0 significa sucesso) antes de imprimir a mensagem padrão
if crontab -l >/dev/null 2>&1; then
    crontab -l >> $OUTPUT_FILE 2>&1
else
    echo "  Nenhum crontab configurado para o usuário root ou permissão negada." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "Serviços Habilitados no Boot (systemctl list-unit-files --type=service --state=enabled):" >> $OUTPUT_FILE
systemctl list-unit-files --type=service --state=enabled >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Listando os Jobs do Proxmox como Backups, e sincronizacoes (cat /etc/pve/jobs.cfg):" >> $OUTPUT_FILE
if [ -f /etc/pve/jobs.cfg ]; then
    cat /etc/pve/jobs.cfg >> $OUTPUT_FILE
else
    echo "  Arquivo /etc/pve/jobs.cfg não encontrado ou sem jobs configurados." >> $OUTPUT_FILE
fi
echo "" >> $OUTPUT_FILE

echo "### FIM DA DOCUMENTAÇÃO ###" >> $OUTPUT_FILE
echo "As informações foram salvas em: $OUTPUT_FILE" >> $OUTPUT_FILE
echo "===========================" >> $OUTPUT_FILE

# Mensagens finais para o terminal
echo ""
echo "Documentação gerada com sucesso em: $OUTPUT_FILE"
echo "==================================================="
echo ""
