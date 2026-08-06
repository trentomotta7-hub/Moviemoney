import { trpc } from "@/lib/trpc";
import { isValidOfferToken } from "@shared/lead";
import { ArrowLeft, Check, Clock3, Loader2, ShieldCheck } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { Link, useRoute } from "wouter";

const logo = "/manus-storage/logo_0fe6c467.png";

function formatRemaining(milliseconds: number) {
  const safe = Math.max(0, milliseconds);
  const totalSeconds = Math.floor(safe / 1000);
  const days = Math.floor(totalSeconds / 86_400);
  const hours = Math.floor((totalSeconds % 86_400) / 3_600);
  const minutes = Math.floor((totalSeconds % 3_600) / 60);
  const seconds = totalSeconds % 60;
  return { days, hours, minutes, seconds };
}

export default function Offer() {
  const [, params] = useRoute<{ token: string }>("/oferta/:token");
  const token = params?.token ?? "";
  const hasValidToken = isValidOfferToken(token);
  const queryInput = useMemo(() => ({ accessToken: token }), [token]);
  const offer = trpc.leads.offer.useQuery(queryInput, { enabled: hasValidToken, retry: false });
  const [remainingMs, setRemainingMs] = useState(0);

  useEffect(() => {
    if (!offer.data) return;
    const serverOffset = offer.data.serverNowMs - Date.now();
    const update = () => setRemainingMs(Math.max(0, offer.data.offerExpiresAtMs - (Date.now() + serverOffset)));
    update();
    const timer = window.setInterval(update, 1000);
    return () => window.clearInterval(timer);
  }, [offer.data]);

  const remaining = formatRemaining(remainingMs);

  if (offer.isLoading) {
    return <div className="mm-page flex min-h-screen items-center justify-center bg-background text-cyan-300"><Loader2 className="size-8 animate-spin" /><span className="sr-only">Carregando oferta</span></div>;
  }

  if (!hasValidToken || offer.error) {
    return (
      <div className="mm-page flex min-h-screen items-center justify-center bg-background px-5 text-foreground">
        <div className="mm-machine-card max-w-lg p-8 text-center">
          <Clock3 className="mx-auto size-8 text-rose-400" />
          <h1 className="mt-6 text-3xl font-black uppercase text-white">Acesso não encontrado</h1>
          <p className="mt-4 text-sm leading-7 text-zinc-500">Confira o link recebido ou faça um novo cadastro na landing.</p>
          <Link href="/" className="mm-button mt-7 justify-center"><ArrowLeft className="size-4" /> Voltar à landing</Link>
        </div>
      </div>
    );
  }

  const data = offer.data;
  if (!data) return null;
  const expired = data.expired || remainingMs <= 0;

  return (
    <div className="mm-page min-h-screen bg-background text-foreground">
      <header className="border-b border-white/10">
        <div className="container flex h-20 items-center justify-between">
          <Link href="/"><img src={logo} alt="Movie Money" className="h-8 w-auto" /></Link>
          <div className="flex items-center gap-2 font-mono text-[9px] uppercase tracking-[0.16em] text-cyan-300"><ShieldCheck className="size-4" /> acesso individual</div>
        </div>
      </header>
      <main className="relative py-20 md:py-28">
        <div aria-hidden className="absolute inset-0 bg-[linear-gradient(rgba(0,229,255,0.03)_1px,transparent_1px),linear-gradient(90deg,rgba(0,229,255,0.03)_1px,transparent_1px)] bg-[size:54px_54px]" />
        <div className="container relative">
          <div className="mx-auto max-w-5xl">
            <p className="font-mono text-[10px] uppercase tracking-[0.2em] text-cyan-300">oferta autenticada por token</p>
            <h1 className="mt-5 max-w-4xl text-5xl font-black uppercase leading-[0.9] tracking-[-0.055em] text-white md:text-7xl">{expired ? "Seu prazo chegou ao fim." : `Seu próximo ciclo começa aqui, ${data.name}.`}</h1>
            <p className="mt-7 max-w-2xl text-lg leading-8 text-zinc-400">O contador abaixo usa o prazo registrado no servidor no momento do seu primeiro cadastro. Recarregar a página não reinicia a oferta.</p>

            <div className={`mt-12 grid gap-px border ${expired ? 'border-rose-400/25 bg-rose-400/20' : 'border-cyan-300/25 bg-cyan-300/20'} sm:grid-cols-4`}>
              {[
                [remaining.days, "dias"],
                [remaining.hours, "horas"],
                [remaining.minutes, "minutos"],
                [remaining.seconds, "segundos"],
              ].map(([value, label]) => (
                <div key={label} className="bg-[#070a0a] p-7 text-center">
                  <strong className="block text-5xl font-black tabular-nums text-white">{String(value).padStart(2, '0')}</strong>
                  <span className="mt-2 block font-mono text-[9px] uppercase tracking-[0.18em] text-zinc-600">{label}</span>
                </div>
              ))}
            </div>

            <div className="mt-8 grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
              <div className="mm-machine-card p-8 md:p-10">
                <p className="font-mono text-[9px] uppercase tracking-[0.18em] text-rose-400">blueprint inicial</p>
                <h2 className="mt-4 text-3xl font-black uppercase text-white">O que a conversa vai mapear</h2>
                <div className="mt-7 grid gap-4 sm:grid-cols-2">
                  {["Gargalo atual da operação", "Formato mais coerente", "Hipótese de hook e prova", "Próximo teste documentado"].map(item => <div key={item} className="flex gap-3 text-sm leading-6 text-zinc-400"><Check className="mt-1 size-4 shrink-0 text-cyan-300" />{item}</div>)}
                </div>
              </div>
              <div className="border border-white/10 bg-white/[0.02] p-8 md:p-10">
                <Clock3 className={`size-6 ${expired ? 'text-rose-400' : 'text-cyan-300'}`} />
                <h2 className="mt-6 text-2xl font-bold text-white">{expired ? "Cadastro preservado" : "Solicitação recebida"}</h2>
                <p className="mt-3 text-sm leading-7 text-zinc-500">{expired ? "Seu lead continua registrado. A equipe poderá orientar sobre uma nova condição disponível." : "Seu acesso está ativo e a Movie Money já possui os dados necessários para conduzir o primeiro contato."}</p>
                <Link href="/" className="mt-7 inline-flex items-center gap-2 font-mono text-[10px] uppercase tracking-[0.15em] text-cyan-300"><ArrowLeft className="size-4" /> Revisar a landing</Link>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
