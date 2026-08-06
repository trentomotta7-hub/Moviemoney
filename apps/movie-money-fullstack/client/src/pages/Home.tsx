import { trpc } from "@/lib/trpc";
import {
  ArrowDownRight,
  ArrowRight,
  BadgeCheck,
  Check,
  ChevronDown,
  CirclePlay,
  Clock3,
  Film,
  Fingerprint,
  Layers3,
  Loader2,
  ScanLine,
  ShieldCheck,
  Sparkles,
  Terminal,
  WandSparkles,
  Zap,
} from "lucide-react";
import { FormEvent, useState } from "react";
import { useLocation } from "wouter";

const assets = {
  logo: "/manus-storage/logo_0fe6c467.png",
  beto: "/manus-storage/beto_f2aa828e.png",
  marina: "/manus-storage/marina_costa_dfaaffb8.png",
  lucas: "/manus-storage/lucas_ferreira_c385f40c.png",
  rafael: "/manus-storage/rafael_santos_6d7b7a0a.png",
  beatriz: "/manus-storage/beatriz_oliveira_ee30e83a.png",
  diego: "/manus-storage/diego_almeida_3fe19e29.png",
  pov: "/manus-storage/pov-sunscreen_15b2d65f.mp4",
  gc: "/manus-storage/gc-sunscreen_75916b0c.mp4",
} as const;

const cast = [
  { name: "Beto", role: "Porta-voz · estratégia", image: assets.beto, accent: "cyan" },
  { name: "Marina", role: "Beauty · lifestyle", image: assets.marina, accent: "pink" },
  { name: "Lucas", role: "Tech · utilidades", image: assets.lucas, accent: "cyan" },
  { name: "Rafael", role: "Fitness · performance", image: assets.rafael, accent: "pink" },
  { name: "Beatriz", role: "Casa · bem-estar", image: assets.beatriz, accent: "cyan" },
  { name: "Diego", role: "Urbano · tendência", image: assets.diego, accent: "pink" },
] as const;

const formats = [
  ["01", "POV", "A experiência do produto pela perspectiva de quem usa."],
  ["02", "Green Screen", "Comentário ágil com contexto visual e demonstração."],
  ["03", "Unboxing", "Descoberta, textura, detalhe e recompensa visual."],
  ["04", "Split Screen", "Problema e solução apresentados no mesmo quadro."],
  ["05", "Lista", "Benefícios organizados para retenção e clareza."],
  ["06", "Reaction", "A conversa cultural vira uma ponte para o produto."],
] as const;

const faqs = [
  ["O que acontece depois do cadastro?", "Você recebe um acesso individual à oferta e a Movie Money registra seu interesse para conduzir o diagnóstico inicial."],
  ["O countdown reinicia se eu recarregar?", "Não. O prazo é gravado no servidor no primeiro cadastro e continua correndo independentemente do navegador ou de recargas."],
  ["Os personagens são consistentes entre vídeos?", "A produção parte de referências mestras e de um protocolo de continuidade visual para reduzir variações de identidade entre takes."],
  ["Vocês usam voz robótica sobre um rosto parado?", "O pipeline prioriza fala nativa ou sincronização validada. Cada master passa por verificação técnica antes de ser classificado como final."],
  ["Funciona para qualquer nicho?", "O diagnóstico avalia produto, público, promessa e restrições da categoria. A recomendação de formato é feita depois dessa leitura, não por um template genérico."],
  ["Meus dados ficam protegidos?", "Nome, e-mail e consentimento são usados para atender sua solicitação. O consentimento LGPD é obrigatório e registrado com timestamp no servidor."],
] as const;

function SectionLabel({ index, children }: { index: string; children: React.ReactNode }) {
  return (
    <div className="mm-label">
      <span>{index}</span>
      <span className="h-px w-7 bg-current opacity-50" />
      <span>{children}</span>
    </div>
  );
}

function scrollToCapture() {
  document.getElementById("capture")?.scrollIntoView({ behavior: "smooth", block: "start" });
}

export default function Home() {
  const [, navigate] = useLocation();
  const [form, setForm] = useState({ name: "", email: "", consent: false });
  const captureLead = trpc.leads.capture.useMutation({
    onSuccess: data => navigate(`/oferta/${data.accessToken}`),
  });

  const submit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!form.consent) return;
    captureLead.mutate({
      name: form.name,
      email: form.email,
      lgpdConsent: true,
    });
  };

  return (
    <div className="mm-page min-h-screen overflow-hidden bg-background text-foreground">
      <div aria-hidden className="mm-noise" />
      <header className="sticky top-0 z-50 border-b border-white/10 bg-[#050707]/88 backdrop-blur-xl">
        <div className="container flex h-18 items-center justify-between gap-5">
          <a href="#top" className="flex items-center gap-3" aria-label="Movie Money — início">
            <img src={assets.logo} alt="Movie Money" className="h-8 w-auto object-contain" />
            <span className="hidden font-mono text-[9px] tracking-[0.25em] text-cyan-300/80 sm:inline">SISTEMA ATIVO</span>
          </a>
          <nav className="hidden items-center gap-7 font-mono text-[10px] uppercase tracking-[0.18em] text-zinc-400 lg:flex" aria-label="Navegação principal">
            <a href="#diagnostico" className="transition-colors hover:text-cyan-300">Diagnóstico</a>
            <a href="#elenco" className="transition-colors hover:text-cyan-300">Elenco</a>
            <a href="#demos" className="transition-colors hover:text-cyan-300">Demos</a>
            <a href="#faq" className="transition-colors hover:text-cyan-300">FAQ</a>
          </nav>
          <button type="button" onClick={scrollToCapture} className="mm-button mm-button-small">
            Quero meu diagnóstico <ArrowDownRight className="size-4" />
          </button>
        </div>
      </header>

      <main>
        <section id="top" data-section="01-hero" className="relative border-b border-white/10 pb-20 pt-16 md:pb-28 md:pt-24">
          <div aria-hidden className="mm-orb left-[-12rem] top-[-10rem] bg-cyan-400/15" />
          <div aria-hidden className="mm-orb bottom-[-12rem] right-[-10rem] bg-rose-500/12" />
          <div className="container relative grid items-center gap-14 lg:grid-cols-[1.15fr_0.85fr]">
            <div>
              <SectionLabel index="01">criativos viram infraestrutura</SectionLabel>
              <div className="mb-7 inline-flex items-center gap-2 border border-rose-400/25 bg-rose-500/8 px-3 py-2 font-mono text-[10px] uppercase tracking-[0.16em] text-rose-300">
                <Zap className="size-3.5" /> Sua mídia não precisa de mais um vídeo genérico
              </div>
              <h1 className="max-w-4xl text-[clamp(3.8rem,8vw,7.8rem)] font-black uppercase leading-[0.82] tracking-[-0.07em] text-white">
                Criativos que <span className="mm-glitch-text" data-text="param">param</span> a rolagem.
              </h1>
              <p className="mt-8 max-w-2xl text-lg leading-8 text-zinc-400 md:text-xl">
                A Movie Money transforma pesquisa, roteiro, elenco e pós-produção em um sistema contínuo de criativos para TikTok Shop e e-commerce.
              </p>
              <div className="mt-9 flex flex-col gap-3 sm:flex-row">
                <button type="button" onClick={scrollToCapture} className="mm-button">
                  Quero meu plano de criativos <ArrowRight className="size-5" />
                </button>
                <a href="#demos" className="mm-button mm-button-ghost">
                  <CirclePlay className="size-5" /> Ver masters reais
                </a>
              </div>
              <div className="mt-10 flex flex-wrap gap-2 font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-500">
                {['HOOK: 1.5S', 'LIP_SYNC: VALIDADO', 'SAFE_ZONE: ATIVA', 'FORMATOS: 06'].map(item => (
                  <span key={item} className="border border-white/10 bg-white/[0.02] px-3 py-2">{item}</span>
                ))}
              </div>
            </div>

            <div className="relative mx-auto w-full max-w-[520px]">
              <div className="mm-machine-card aspect-[4/5] overflow-hidden p-3">
                <div className="relative h-full overflow-hidden bg-[#0b1010]">
                  <img src={assets.beto} alt="Beto, porta-voz da Movie Money" className="h-full w-full object-cover object-top grayscale-[0.08]" />
                  <div className="absolute inset-0 bg-gradient-to-t from-[#030505] via-transparent to-cyan-400/5" />
                  <div className="absolute left-4 top-4 flex items-center gap-2 border border-cyan-300/25 bg-black/60 px-2 py-1 font-mono text-[8px] tracking-[0.18em] text-cyan-300 backdrop-blur">
                    <span className="size-1.5 animate-pulse rounded-full bg-cyan-300" /> ATIVO
                  </div>
                  <div className="absolute inset-x-4 bottom-4 border border-white/10 bg-black/70 p-4 backdrop-blur">
                    <p className="font-bold text-white">Beto</p>
                    <p className="mt-1 font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-500">estratégia · direção · GC</p>
                  </div>
                </div>
              </div>
              <div aria-hidden className="absolute -right-5 top-1/3 hidden font-mono text-[8px] uppercase tracking-[0.2em] text-cyan-300/60 [writing-mode:vertical-rl] md:block">personagem mestre // identidade persistente</div>
            </div>
          </div>
        </section>

        <section data-section="02-proposta" className="border-b border-white/10 bg-cyan-300 text-[#041010]">
          <div className="container grid divide-y divide-black/15 md:grid-cols-3 md:divide-x md:divide-y-0">
            {[
              ["06", "personas prontas para contexto"],
              ["02", "masters reais nesta página"],
              ["72h", "de oferta individual persistida"],
            ].map(([value, label]) => (
              <div key={label} className="flex items-baseline gap-4 py-6 md:px-8 md:first:pl-0">
                <strong className="text-4xl font-black tracking-[-0.06em]">{value}</strong>
                <span className="max-w-40 font-mono text-[10px] uppercase leading-4 tracking-[0.12em]">{label}</span>
              </div>
            ))}
          </div>
        </section>

        <section id="diagnostico" data-section="03-diagnostico" className="py-24 md:py-32">
          <div className="container">
            <SectionLabel index="03">diagnóstico</SectionLabel>
            <div className="grid gap-12 lg:grid-cols-[0.9fr_1.1fr] lg:gap-20">
              <h2 className="mm-heading">Seu tráfego não corrige um criativo invisível.</h2>
              <div className="grid gap-px bg-white/10 sm:grid-cols-2">
                {[
                  [ScanLine, "Hook sem tensão", "A abertura explica demais e não cria uma razão para continuar."],
                  [Fingerprint, "Conteúdo sem identidade", "A audiência reconhece o template antes de reconhecer o produto."],
                  [Layers3, "Pipeline quebrado", "Pesquisa, roteiro, atuação e edição trabalham como ilhas."],
                  [Clock3, "Volume sem aprendizado", "Mais peças são publicadas, mas nenhuma hipótese fica documentada."],
                ].map(([Icon, title, text]) => {
                  const IconComponent = Icon as typeof ScanLine;
                  return (
                    <article key={String(title)} className="bg-[#080b0b] p-7 md:p-8">
                      <IconComponent className="mb-8 size-6 text-rose-400" />
                      <h3 className="text-xl font-bold text-white">{String(title)}</h3>
                      <p className="mt-3 text-sm leading-6 text-zinc-500">{String(text)}</p>
                    </article>
                  );
                })}
              </div>
            </div>
          </div>
        </section>

        <section data-section="04-solucao" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container grid gap-14 lg:grid-cols-2 lg:items-center">
            <div>
              <SectionLabel index="04">a máquina</SectionLabel>
              <h2 className="mm-heading">Uma operação criativa, não uma pasta de vídeos.</h2>
              <p className="mt-7 max-w-xl text-base leading-8 text-zinc-400">Cada entrega nasce de uma hipótese clara: quem precisa parar, qual tensão deve reconhecer e qual prova visual reduz a dúvida. O master final preserva essa lógica para a próxima iteração.</p>
              <button type="button" onClick={scrollToCapture} className="mt-8 inline-flex items-center gap-2 font-mono text-xs uppercase tracking-[0.14em] text-cyan-300 transition-all hover:gap-4">
                Diagnosticar minha operação <ArrowRight className="size-4" />
              </button>
            </div>
            <div className="mm-terminal">
              <div className="flex items-center justify-between border-b border-white/10 px-5 py-4 font-mono text-[9px] uppercase tracking-[0.18em] text-zinc-500">
                <span>movie_money.pipeline</span><span className="text-emerald-400">● online</span>
              </div>
              <div className="space-y-5 p-6 font-mono text-xs md:p-8">
                {[
                  ["01", "insight", "dor + desejo + linguagem"],
                  ["02", "roteiro", "hook + mecanismo + CTA"],
                  ["03", "produção", "personagem + produto + contexto"],
                  ["04", "auditoria", "fala + corte + safe zone"],
                ].map(([step, title, value]) => (
                  <div key={step} className="grid grid-cols-[34px_1fr] gap-4">
                    <span className="text-cyan-300">{step}</span>
                    <div className="border-b border-dashed border-white/10 pb-5">
                      <span className="text-white">{title}</span><span className="text-zinc-600"> :: </span><span className="text-zinc-400">{value}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        <section data-section="05-formatos" className="py-24 md:py-32">
          <div className="container">
            <SectionLabel index="05">formatos</SectionLabel>
            <div className="mb-14 grid gap-6 lg:grid-cols-[1.1fr_0.9fr] lg:items-end">
              <h2 className="mm-heading">Uma ideia não deveria depender de um único formato.</h2>
              <p className="max-w-xl text-base leading-8 text-zinc-500 lg:justify-self-end">O formato muda a experiência da mesma promessa. A Movie Money escolhe a linguagem pelo comportamento que o produto precisa provocar.</p>
            </div>
            <div className="grid gap-px overflow-hidden border border-white/10 bg-white/10 md:grid-cols-2 lg:grid-cols-3">
              {formats.map(([number, title, description]) => (
                <article key={title} className="group min-h-56 bg-[#060808] p-7 transition-colors hover:bg-[#0b1111]">
                  <div className="mb-12 flex items-start justify-between">
                    <span className="font-mono text-[10px] tracking-[0.2em] text-cyan-300">FMT_{number}</span>
                    <ArrowDownRight className="size-5 text-zinc-700 transition-colors group-hover:text-rose-400" />
                  </div>
                  <h3 className="text-2xl font-bold text-white">{title}</h3>
                  <p className="mt-3 text-sm leading-6 text-zinc-500">{description}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section id="elenco" data-section="06-elenco" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container">
            <SectionLabel index="06">elenco proprietário</SectionLabel>
            <div className="mb-12 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <h2 className="mm-heading max-w-3xl">Rostos que voltam. Identidades que acumulam memória.</h2>
              <p className="max-w-sm text-sm leading-7 text-zinc-500">O elenco permite construir recorrência de linguagem sem transformar cada campanha em um recomeço.</p>
            </div>
            <div className="grid grid-cols-2 gap-3 md:grid-cols-3 lg:grid-cols-6">
              {cast.map(person => (
                <article key={person.name} className="mm-cast-card group">
                  <div className="aspect-[4/5] overflow-hidden bg-[#101414]">
                    <img src={person.image} alt={`${person.name}, personagem Movie Money`} className="h-full w-full object-cover object-top grayscale-[0.2] transition duration-500 group-hover:scale-[1.03] group-hover:grayscale-0" loading="lazy" />
                  </div>
                  <div className="border-t border-white/10 p-4">
                    <h3 className="font-bold text-white">{person.name}</h3>
                    <p className={`mt-1 font-mono text-[8px] uppercase tracking-[0.12em] ${person.accent === 'cyan' ? 'text-cyan-300' : 'text-rose-400'}`}>{person.role}</p>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section data-section="07-pipeline" className="py-24 md:py-32">
          <div className="container">
            <SectionLabel index="07">pipeline</SectionLabel>
            <h2 className="mm-heading max-w-4xl">Da tensão do cliente ao arquivo pronto para teste.</h2>
            <div className="relative mt-16 grid gap-8 md:grid-cols-4">
              <div aria-hidden className="absolute left-0 right-0 top-6 hidden h-px bg-gradient-to-r from-cyan-300 via-white/15 to-rose-400 md:block" />
              {[
                ["A", "Diagnóstico", "Leitura do produto, da oferta e do gargalo criativo."],
                ["B", "Arquitetura", "Escolha do formato, hook, personagem e prova visual."],
                ["C", "Produção", "Geração dos takes, fala, montagem e tratamento."],
                ["D", "Auditoria", "Verificação técnica e registro do que aprender no teste."],
              ].map(([letter, title, text]) => (
                <article key={letter} className="relative pt-1 md:pt-14">
                  <div className="absolute left-0 top-0 z-10 flex size-12 items-center justify-center border border-cyan-300/40 bg-[#050707] font-mono text-xs text-cyan-300">{letter}</div>
                  <h3 className="text-xl font-bold text-white">{title}</h3>
                  <p className="mt-3 text-sm leading-6 text-zinc-500">{text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section id="demos" data-section="08-demos" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container">
            <SectionLabel index="08">masters reais</SectionLabel>
            <div className="mb-12 grid gap-6 lg:grid-cols-2 lg:items-end">
              <h2 className="mm-heading">Não é mockup. Dê play no que já saiu da máquina.</h2>
              <p className="max-w-xl text-base leading-8 text-zinc-500 lg:justify-self-end">Dois formatos do mesmo produto mostram como a linguagem muda sem abandonar a mensagem central.</p>
            </div>
            <div className="grid gap-6 lg:grid-cols-2">
              {[
                [assets.pov, "POV · Sunscreen Stick", "Experiência de uso, fricção cotidiana e solução direta."],
                [assets.gc, "Green Screen · Sunscreen Stick", "Comentário em câmera com demonstração e contexto visual."],
              ].map(([video, title, text]) => (
                <article key={title} className="mm-machine-card p-3">
                  <div className="grid gap-4 bg-[#030505] p-3 sm:grid-cols-[190px_1fr] sm:items-center">
                    <video src={video} controls playsInline preload="metadata" className="mx-auto aspect-[9/16] max-h-[500px] w-full bg-black object-cover" aria-label={title} />
                    <div className="p-3 sm:p-6">
                      <Film className="size-6 text-rose-400" />
                      <h3 className="mt-8 text-2xl font-bold text-white">{title}</h3>
                      <p className="mt-3 text-sm leading-7 text-zinc-500">{text}</p>
                      <div className="mt-8 flex flex-wrap gap-2 font-mono text-[8px] uppercase tracking-[0.14em] text-zinc-600">
                        <span className="border border-white/10 px-2 py-1">vertical</span>
                        <span className="border border-white/10 px-2 py-1">pt-br</span>
                        <span className="border border-white/10 px-2 py-1">master</span>
                      </div>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section data-section="09-tecnologia" className="py-24 md:py-32">
          <div className="container grid gap-14 lg:grid-cols-[0.85fr_1.15fr] lg:items-start">
            <div className="lg:sticky lg:top-28">
              <SectionLabel index="09">engenharia criativa</SectionLabel>
              <h2 className="mm-heading">O detalhe técnico também vende.</h2>
              <p className="mt-6 text-base leading-8 text-zinc-500">O objetivo não é exibir tecnologia. É remover as pequenas falhas que quebram confiança, retenção e clareza.</p>
            </div>
            <div className="space-y-3">
              {[
                [WandSparkles, "Lip sync auditável", "Fala e movimento são verificados no master, não presumidos pela geração."],
                [ShieldCheck, "Safe zone de interface", "Texto, rosto e produto respeitam as áreas ocupadas pela plataforma."],
                [Terminal, "Pipeline reprodutível", "Scripts e checkpoints preservam decisões entre versões e sessões."],
                [Sparkles, "Variação com hipótese", "Hooks e CTAs mudam de forma controlada para produzir aprendizado útil."],
              ].map(([Icon, title, text], index) => {
                const IconComponent = Icon as typeof WandSparkles;
                return (
                  <article key={String(title)} className="group grid gap-5 border border-white/10 bg-white/[0.015] p-6 transition-colors hover:border-cyan-300/25 sm:grid-cols-[52px_1fr_auto] sm:items-center">
                    <div className="flex size-12 items-center justify-center border border-white/10 text-cyan-300"><IconComponent className="size-5" /></div>
                    <div><h3 className="font-bold text-white">{String(title)}</h3><p className="mt-1 text-sm leading-6 text-zinc-500">{String(text)}</p></div>
                    <span className="font-mono text-[9px] text-zinc-700">SYS_{String(index + 1).padStart(2, '0')}</span>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        <section data-section="10-prova" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container">
            <SectionLabel index="10">prova pelo processo</SectionLabel>
            <div className="grid gap-12 lg:grid-cols-[1fr_1fr]">
              <div>
                <h2 className="mm-heading">Sem depoimento inventado. Sem número decorativo.</h2>
                <p className="mt-7 max-w-xl text-base leading-8 text-zinc-400">A prova disponível hoje está no que pode ser inspecionado: elenco próprio, masters reproduzíveis, documentação de produção e dois formatos reais publicados nesta página.</p>
              </div>
              <div className="grid gap-3 sm:grid-cols-2">
                {[
                  [BadgeCheck, "Identidade", "6 personagens com referência visual"],
                  [Film, "Execução", "2 masters reproduzíveis nesta landing"],
                  [Terminal, "Rastreabilidade", "Roteiros, scripts e checkpoints"],
                  [ShieldCheck, "Controle", "Auditoria antes do status final"],
                ].map(([Icon, title, text]) => {
                  const IconComponent = Icon as typeof BadgeCheck;
                  return <div key={String(title)} className="border border-white/10 bg-[#050707] p-6"><IconComponent className="size-5 text-cyan-300" /><h3 className="mt-8 font-bold text-white">{String(title)}</h3><p className="mt-2 text-xs leading-5 text-zinc-500">{String(text)}</p></div>;
                })}
              </div>
            </div>
          </div>
        </section>

        <section id="capture" data-section="11-oferta-captura" className="relative py-24 md:py-32">
          <div aria-hidden className="mm-orb left-1/2 top-1/2 bg-rose-500/10" />
          <div className="container relative">
            <SectionLabel index="11">oferta de entrada</SectionLabel>
            <div className="mm-offer-grid overflow-hidden border border-cyan-300/25 bg-[#070a0a]">
              <div className="p-8 md:p-12 lg:p-16">
                <p className="font-mono text-[10px] uppercase tracking-[0.2em] text-rose-400">acesso individual · 72 horas</p>
                <h2 className="mt-5 max-w-3xl text-4xl font-black uppercase leading-[0.95] tracking-[-0.05em] text-white md:text-6xl">Diagnóstico + blueprint do seu próximo ciclo criativo.</h2>
                <p className="mt-7 max-w-2xl text-base leading-8 text-zinc-400">O cadastro libera uma página individual com prazo persistente e registra seu interesse para a conversa inicial com a Movie Money.</p>
                <div className="mt-9 grid gap-3 sm:grid-cols-2">
                  {["Leitura do gargalo criativo atual", "Recomendação inicial de formatos", "Direção de hook, prova e CTA", "Próximo passo de produção documentado"].map(item => <div key={item} className="flex gap-3 text-sm text-zinc-300"><Check className="mt-0.5 size-4 shrink-0 text-cyan-300" />{item}</div>)}
                </div>
              </div>
              <form onSubmit={submit} className="border-t border-white/10 p-8 md:p-12 lg:border-l lg:border-t-0" noValidate>
                <div className="mb-8 flex items-center justify-between border-b border-white/10 pb-5">
                  <div><p className="font-mono text-[9px] uppercase tracking-[0.2em] text-cyan-300">lead.capture</p><p className="mt-1 text-sm text-zinc-500">Campos obrigatórios</p></div>
                  <span className="size-2 animate-pulse rounded-full bg-emerald-400" aria-label="Sistema online" />
                </div>
                <label className="mm-field">
                  <span>Nome</span>
                  <input required minLength={2} maxLength={160} autoComplete="name" value={form.name} onChange={event => setForm(current => ({ ...current, name: event.target.value }))} placeholder="Como podemos chamar você?" />
                </label>
                <label className="mm-field mt-5">
                  <span>E-mail</span>
                  <input required type="email" maxLength={320} autoComplete="email" value={form.email} onChange={event => setForm(current => ({ ...current, email: event.target.value }))} placeholder="voce@empresa.com" />
                </label>
                <label className="mt-6 flex cursor-pointer items-start gap-3 text-xs leading-5 text-zinc-500">
                  <input required type="checkbox" checked={form.consent} onChange={event => setForm(current => ({ ...current, consent: event.target.checked }))} className="mt-0.5 size-4 shrink-0 accent-cyan-300" />
                  <span>Concordo com o uso dos meus dados para responder a esta solicitação e apresentar a oferta Movie Money, conforme a LGPD.</span>
                </label>
                {captureLead.error && <p role="alert" className="mt-5 border border-rose-400/20 bg-rose-500/5 p-3 text-xs leading-5 text-rose-300">Não foi possível concluir o cadastro. Verifique os campos e tente novamente.</p>}
                <button type="submit" disabled={captureLead.isPending || !form.consent} className="mm-button mt-7 w-full justify-center disabled:cursor-not-allowed disabled:opacity-40">
                  {captureLead.isPending ? <><Loader2 className="size-5 animate-spin" /> Gravando acesso</> : <>Liberar meu acesso de 72h <ArrowRight className="size-5" /></>}
                </button>
                <div className="mt-5 flex items-center justify-center gap-2 font-mono text-[8px] uppercase tracking-[0.14em] text-zinc-600"><ShieldCheck className="size-3.5" /> prazo calculado e persistido no servidor</div>
              </form>
            </div>
          </div>
        </section>

        <section id="faq" data-section="12-faq" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container grid gap-12 lg:grid-cols-[0.72fr_1.28fr]">
            <div>
              <SectionLabel index="12">faq</SectionLabel>
              <h2 className="mm-heading">Antes de entrar na máquina.</h2>
            </div>
            <div className="divide-y divide-white/10 border-y border-white/10">
              {faqs.map(([question, answer]) => (
                <details key={question} className="group py-1">
                  <summary className="flex list-none items-center justify-between gap-6 py-6 text-left font-bold text-white marker:content-none">
                    {question}<ChevronDown className="size-4 shrink-0 text-cyan-300 transition-transform group-open:rotate-180" />
                  </summary>
                  <p className="max-w-2xl pb-7 pr-10 text-sm leading-7 text-zinc-500">{answer}</p>
                </details>
              ))}
            </div>
          </div>
        </section>

        <section data-section="13-cta-final" className="relative py-24 md:py-36">
          <div aria-hidden className="absolute inset-0 bg-[linear-gradient(rgba(0,229,255,0.035)_1px,transparent_1px),linear-gradient(90deg,rgba(0,229,255,0.035)_1px,transparent_1px)] bg-[size:52px_52px]" />
          <div className="container relative grid gap-14 lg:grid-cols-[1fr_0.64fr] lg:items-center">
            <div>
              <SectionLabel index="13">cta final</SectionLabel>
              <h2 className="max-w-4xl text-[clamp(3.2rem,7vw,7rem)] font-black uppercase leading-[0.84] tracking-[-0.065em] text-white">Pare de comprar vídeos. Comece a construir uma operação.</h2>
              <p className="mt-8 max-w-xl text-lg leading-8 text-zinc-400">Seu formulário está logo acima. O primeiro passo leva menos tempo do que continuar improvisando o próximo criativo.</p>
            </div>
            <div className="mm-machine-card bg-[#070a0a] p-8 md:p-10">
              <p className="font-mono text-[9px] uppercase tracking-[0.2em] text-rose-400">última chamada // acesso 72h</p>
              <p className="mt-5 text-lg font-semibold leading-7 text-white">Volte ao formulário, registre seu prazo individual e abra a página segura da oferta.</p>
              <button type="button" onClick={scrollToCapture} className="mm-button mt-8 w-full justify-center">Ir para o formulário <ArrowRight className="size-5" /></button>
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t border-white/10 py-9">
        <div className="container flex flex-col justify-between gap-5 text-xs text-zinc-600 md:flex-row md:items-center">
          <img src={assets.logo} alt="Movie Money" className="h-7 w-auto object-contain opacity-80" />
          <p>© 2026 Movie Money. Criatividade com processo, evidência e continuidade.</p>
          <a href="#top" className="font-mono uppercase tracking-[0.14em] text-cyan-300">voltar ao topo ↑</a>
        </div>
      </footer>
    </div>
  );
}
