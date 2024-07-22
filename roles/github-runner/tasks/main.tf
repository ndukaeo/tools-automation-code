# Following steps need to be run manually
# sudo curl -L -o /etc/yum.repos.d/gh-cli.repo https://cli.github.com/packages/rpm/gh-cli.repo
# sudo dnf install gh -y
# gh auth login
# gh auth refresh -h github.com -s admin:org

- name: Setup Prompt
  ansible.builtin.shell: set-prompt github-runner

- name: Add Github Runner User
  ansible.builtin.user:
    name: grunner

- name: Create github directory
  ansible.builtin.file:
    path: /actions-runner
    state: directory
    owner: grunner
    group: grunner

- name: Download & Extract Runner
  ansible.builtin.unarchive:
    src: https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
    dest: "/actions-runner"
    remote_src: yes
    owner: grunner
    group: grunner

# - name: Grab Token
# ansible.builtin.shell: |
# gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/raghudevopsb80/actions/runners/registration-token | jq .token
# register: token
# become_user: ec2-user # Token can be fetched by ec2-user as gh login was done by that user.
#
# - name: Print token
# ansible.builtin.debug:
# msg: "{{ token }}"
#
# - name: Install libicu dependency
# ansible.builtin.dnf:
# name: libicu
# state: latest
#
# - name: Get the runner count
# ansible.builtin.shell: |
# gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/raghudevopsb80/actions/runners | jq .total_count |xargs
# register: runner_count
# become_user: ec2-user
#
# - name: Configure Github Runner
# ansible.builtin.shell: ./config.sh --url https://github.com/raghudevopsb80 --token {{ token.stdout }} --runnergroup Default --name ec2 --labels rhel --work _work --replace
# args:
# chdir: /actions-runner
# become_user: grunner
# when: runner_count.stdout == "0"
#
# - name: Install Runner Service
# ansible.builtin.shell: ./svc.sh install grunner ;  ./svc.sh start
# args:
# chdir: /actions-runner
# when: runner_count.stdout == "0"
#
# - name: Download Terraform Repo file
# ansible.builtin.get_url:
# url: https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# dest: /etc/yum.repos.d/hashicorp.repo
#
# - name: Install Terraform
# ansible.builtin.dnf:
# name: terraform
# state: latest
#
#
#
#
#
