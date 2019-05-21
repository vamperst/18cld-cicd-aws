## Montar um delivery continua com AWS CodePipeline , AWS CodeDeploy, Terraform, e Docker

1. No console AWS crie um bucket S3 com o nome 'express-app-testing-demo-<NOME DIFERENCIANDO>'. Coloque no final o que quiser, vale lembrar que nomes de buckets são unicos em toda a AWS não só na conta em questão.
   ![](images/createbucket.png)
2. Após colocar o nome pode clicar direto em criar no canto inferior esquerdo.
3. Após criado, entre no bucket, vá na aba `Propriedades` e clique em `Controle de Versão`
4. Habilite essa propriedade para que o codePipeline possa identificar uma nova versão dos arquivos
   ![](images/versioncontrol2.png)
5. Crie uma pasta no bucket com o nome 'instance-need'
   ![](images/instance-need-folder.png)
6. Dentro da pasta recem criada crie 3 pastas
   1. `.ssh`
   2. `.aws`
   3. `prod`
   ![](images/threefolders.png)
7. Dentro da pasta .aws, coloque os arquivos `credentials` e `config` que estão na sua maquina virtual.
8. Dentro da pasta .ssh, coloque a pem criada para acessar as maquinas.
9. Não coloque nada dentro da pasta prod por enquanto.
10. Caso facilide, utilize comandos como esses direto da VM:
    ```
    aws s3 cp ~/.aws/config s3://express-app-testing-demo-teste/instance-need/.aws/config
    aws s3 cp ~/.aws/credentials s3://express-app-testing-demo-teste/instance-need/.aws/credentials
    aws s3 cp fiap-18cld.pem s3://express-app-testing-demo-teste/instance-need/.ssh/fiap-18cld.pem
    ```

    Só não esqueça de trocar o nome do bucket
11. Na maquina virtual vá até onde esta o projeto do git e executem o comando `git fetch && git checkout deploy-stack` para mudar a branch do repositório.
12. Dentro do arquivo `buildspec-deploy.yml` e `buildspec.yml` mude o nome dos buckets para o que criou. Procuro por S3 no arquivo para facilitar.
13. Commit as mudanças e mande para o Git
14. De volta ao painel da AWS vamos criar mais um CodePipeline e CodeDeploy, dessa com source em S3. dessa vez coloque o nome 'express-app-testing-demo-cd' e usando a role criada para o outro pipeline.
    ![](images/pipeline1.png)
15. Clique em next
16. Escolha o Source `Amazon S3`. Ache o seu bucket para selecionar, e na key coloque `instance-need/prod/imagedefinitions.zip`
    ![](images/pipeline2.png)
17. Clique em next
18. Build Provider é o CodeBuild e crie um novo projeto como fez no pipeline anterior.
19. Na janela para criar o build. Coloque o nome `express-app-testing-demo-cd`. A parte de enviromnet fica igual a do exemplo anterior em questão de potencia e configuração das maquinas.
20. Esse build tem 3 variaveis de ambiente:
    1.  ECR_ADDRESS: com o endereço do ECR
    2.  PROJECT_NAME: Nome do projeto sendo feito
    3.  STAGE: qual o estagio desse build
    ![](images/pipelineenv.png)
21. Dessa vez o nome do buildspec é `buildspec-deploy.yml`.
    ![](images/pipeline4.png)
22. Clique em 'continue to pipeline'
23. De volta a tela do pipeline clique em next.
24. Clique em `skip deploy stage`
25. Revise e crie o pipeline
26. 
27. Se tudo der certo você já pode clicar em `Release change` no primeiro pipeline que criou.
