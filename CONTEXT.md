# CONTEXT.md — Movie Money

> Última atualização: 2026-08-07 19:30 UTC
> Sessão: Continuidade — site webdev salvo permanentemente no repositório

## Estado atual do projeto

O projeto **Movie Money** é uma plataforma full-stack de geração de criativos para TikTok Shop, com landing page dark/glitch, captura de leads com countdown de 72h, painel admin e exportação CSV.

### Onde está o código

- **Repositório GitHub:** https://github.com/trentomotta7-hub/Moviemoney.git
- **Branch:** master
- **Código do site web (full-stack):** `apps/movie-money-fullstack/`
- **Stack:** React 19 + Tailwind 4 + Express 4 + tRPC 11 + Drizzle ORM + MySQL

### Projeto webdev ativo

- **Nome:** movie-money-deploy
- **Checkpoint atual:** manus-webdev://4579fb0b
- **URL de preview:** https://3000-i62c3k0x74fmr0ofzne0y-25c53c3b.us2.manus.computer
- **Caminho local:** /home/ubuntu/movie-money-deploy

### O que está implementado

1. Landing page com 13 seções dark/glitch com parallax visível
2. Copy focada em geração de vídeos sem precisar de tempo/equipe
3. Formulário de captura de leads com consentimento LGPD obrigatório
4. Página de oferta com countdown de 72h resistente a recarga
5. Painel admin com métricas, busca, status LGPD e exportação CSV
6. Banco de dados: tabela `leads` com token opaco 64 chars
7. Notificação por e-mail com fallback seguro (RESEND_API_KEY pendente)
8. 10 testes Vitest aprovados, TypeScript sem erros, build OK
9. Parallax com hook useParallax reescrito (parentElement como referência)
10. Componente ParallaxSection com scroll reveal
11. Tipografia Outfit (arredondada), bordas arredondadas em todos os elementos
12. Logo h-20 no header (h-28), 5 imagens de fundo cyberpunk

### Pendências

- [ ] Configurar RESEND_API_KEY e EMAIL_FROM para notificação por e-mail
- [ ] Publicar o site (botão Publish na UI do webdev)

### Como retomar na próxima sessão

1. Clonar o repositório: `gh repo clone trentomotta7-hub/Moviemoney`
2. O código completo do site está em `apps/movie-money-fullstack/`
3. Para rodar localmente: `cd apps/movie-money-fullstack && pnpm install && pnpm dev`
4. O projeto webdev ativo pode ser restaurado pelo checkpoint: manus-webdev://4579fb0b

### Assets

Os assets (logo, personagens, vídeos, backgrounds) estão no storage do webdev:
- Logo: /manus-storage/logo_a27ea66a.png
- 6 personagens: beto, marina, lucas, rafael, beatriz, diego
- 2 vídeos: pov-sunscreen, gc-sunscreen
- 5 backgrounds cyberpunk: bg-hero, bg-stats, bg-problem, bg-offer, bg-cast
