import { useAuth } from "@/_core/hooks/useAuth";
import DashboardLayout from "@/components/DashboardLayout";
import { trpc } from "@/lib/trpc";
import {
  AlertTriangle,
  CheckCircle2,
  Clock3,
  Download,
  Loader2,
  Mail,
  Search,
  ShieldAlert,
  Users,
} from "lucide-react";
import { useMemo, useState } from "react";

function formatDate(value: number | null) {
  if (value == null) return "—";
  return new Date(value).toLocaleString("pt-BR", {
    dateStyle: "short",
    timeStyle: "short",
  });
}

function formatRemaining(milliseconds: number) {
  if (milliseconds <= 0) return "Expirada";
  const totalMinutes = Math.floor(milliseconds / 60_000);
  const days = Math.floor(totalMinutes / 1_440);
  const hours = Math.floor((totalMinutes % 1_440) / 60);
  const minutes = totalMinutes % 60;
  return `${days}d ${hours}h ${minutes}m`;
}

function downloadCsv(fileName: string, content: string) {
  const blob = new Blob([content], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = fileName;
  anchor.click();
  URL.revokeObjectURL(url);
}

function AdminContent() {
  const { user, loading } = useAuth();
  const isAdmin = user?.role === "admin";
  const [search, setSearch] = useState("");
  const leads = trpc.admin.leads.useQuery(undefined, {
    enabled: isAdmin,
    refetchInterval: 60_000,
  });
  const csv = trpc.admin.leadsCsv.useQuery(undefined, { enabled: false });

  const filtered = useMemo(() => {
    const query = search.trim().toLocaleLowerCase("pt-BR");
    if (!query) return leads.data?.items ?? [];
    return (leads.data?.items ?? []).filter(
      lead =>
        lead.name.toLocaleLowerCase("pt-BR").includes(query) ||
        lead.email.toLocaleLowerCase("pt-BR").includes(query),
    );
  }, [leads.data?.items, search]);

  const exportCsv = async () => {
    const result = await csv.refetch();
    if (result.data) downloadCsv(result.data.fileName, result.data.content);
  };

  if (loading) {
    return <div className="flex min-h-[60vh] items-center justify-center text-cyan-300"><Loader2 className="size-7 animate-spin" /><span className="sr-only">Carregando sessão</span></div>;
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto flex min-h-[65vh] max-w-xl items-center px-4">
        <div className="mm-machine-card w-full p-8 text-center">
          <ShieldAlert className="mx-auto size-9 text-rose-400" />
          <h1 className="mt-6 text-3xl font-black uppercase text-white">Acesso administrativo restrito</h1>
          <p className="mt-4 text-sm leading-7 text-zinc-500">A sessão atual não possui a função <code className="text-zinc-300">admin</code>. A autorização também é aplicada no servidor.</p>
        </div>
      </div>
    );
  }

  const summary = leads.data?.summary;

  return (
    <div className="mx-auto max-w-[1500px] px-1 py-2 sm:px-3 sm:py-5">
      <div className="mb-8 flex flex-col justify-between gap-5 lg:flex-row lg:items-end">
        <div>
          <p className="font-mono text-[9px] uppercase tracking-[0.2em] text-cyan-300">movie_money.admin</p>
          <h1 className="mt-3 text-4xl font-black uppercase tracking-[-0.04em] text-white sm:text-5xl">Central de leads</h1>
          <p className="mt-3 max-w-2xl text-sm leading-6 text-zinc-500">Cadastros, consentimento, situação da oferta e entrega de e-mail em uma visão operacional.</p>
        </div>
        <button type="button" onClick={exportCsv} disabled={csv.isFetching} className="mm-button justify-center disabled:opacity-40">
          {csv.isFetching ? <Loader2 className="size-4 animate-spin" /> : <Download className="size-4" />} Exportar CSV
        </button>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        {[
          [Users, "Total", summary?.total ?? 0, "todos os cadastros", "text-white"],
          [Clock3, "Ativas", summary?.active ?? 0, "dentro das 72 horas", "text-cyan-300"],
          [AlertTriangle, "Expiradas", summary?.expired ?? 0, "prazo encerrado", "text-rose-400"],
          [Mail, "E-mails", summary?.emailSent ?? 0, "confirmações enviadas", "text-emerald-400"],
        ].map(([Icon, label, value, note, color]) => {
          const IconComponent = Icon as typeof Users;
          return (
            <article key={String(label)} className="border border-white/10 bg-white/[0.02] p-5">
              <div className="flex items-center justify-between"><span className="font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-600">{String(label)}</span><IconComponent className={`size-4 ${String(color)}`} /></div>
              <strong className="mt-5 block text-4xl font-black tabular-nums text-white">{Number(value)}</strong>
              <span className="mt-1 block text-xs text-zinc-600">{String(note)}</span>
            </article>
          );
        })}
      </div>

      <div className="mt-7 border border-white/10 bg-[#070a0a]">
        <div className="flex flex-col justify-between gap-4 border-b border-white/10 p-4 sm:flex-row sm:items-center">
          <label className="relative block w-full sm:max-w-sm">
            <Search className="absolute left-3 top-1/2 size-4 -translate-y-1/2 text-zinc-600" />
            <span className="sr-only">Buscar por nome ou e-mail</span>
            <input value={search} onChange={event => setSearch(event.target.value)} placeholder="Buscar nome ou e-mail" className="h-11 w-full border border-white/10 bg-black/35 pl-10 pr-3 text-sm text-white outline-none transition-colors placeholder:text-zinc-700 focus:border-cyan-300/45" />
          </label>
          <div className="font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-600">{filtered.length} registro(s) visível(is)</div>
        </div>

        {leads.isLoading ? (
          <div className="flex min-h-64 items-center justify-center text-cyan-300"><Loader2 className="size-6 animate-spin" /><span className="sr-only">Carregando leads</span></div>
        ) : leads.error ? (
          <div className="p-8 text-center text-sm text-rose-300">Não foi possível carregar os leads.</div>
        ) : filtered.length === 0 ? (
          <div className="p-12 text-center"><Users className="mx-auto size-7 text-zinc-700" /><p className="mt-4 text-sm text-zinc-500">Nenhum lead corresponde à busca atual.</p></div>
        ) : (
          <>
            <div className="hidden overflow-x-auto lg:block">
              <table className="w-full min-w-[1050px] border-collapse text-left">
                <thead className="font-mono text-[8px] uppercase tracking-[0.16em] text-zinc-600">
                  <tr>{["Lead", "Cadastro", "LGPD", "Oferta", "E-mail"].map(label => <th key={label} className="border-b border-white/10 px-5 py-4 font-medium">{label}</th>)}</tr>
                </thead>
                <tbody className="divide-y divide-white/10">
                  {filtered.map(lead => (
                    <tr key={lead.id} className="transition-colors hover:bg-white/[0.02]">
                      <td className="px-5 py-5"><p className="font-semibold text-white">{lead.name}</p><p className="mt-1 text-xs text-zinc-500">{lead.email}</p></td>
                      <td className="px-5 py-5 text-xs text-zinc-400">{formatDate(lead.createdAtMs)}</td>
                      <td className="px-5 py-5"><span className="inline-flex items-center gap-2 text-xs text-emerald-400"><CheckCircle2 className="size-3.5" /> Registrado</span><p className="mt-1 text-[10px] text-zinc-600">{formatDate(lead.lgpdConsentedAtMs)}</p></td>
                      <td className="px-5 py-5"><span className={`font-mono text-[10px] uppercase tracking-[0.1em] ${lead.expired ? 'text-rose-400' : 'text-cyan-300'}`}>{formatRemaining(lead.remainingMs)}</span><p className="mt-1 text-[10px] text-zinc-600">até {formatDate(lead.offerExpiresAtMs)}</p></td>
                      <td className="px-5 py-5"><span className={`inline-flex border px-2 py-1 font-mono text-[8px] uppercase tracking-[0.12em] ${lead.emailStatus === 'sent' ? 'border-emerald-400/20 text-emerald-400' : lead.emailStatus === 'failed' ? 'border-rose-400/20 text-rose-400' : 'border-amber-400/20 text-amber-300'}`}>{lead.emailStatus}</span><p className="mt-1 text-[10px] text-zinc-600">{formatDate(lead.emailSentAtMs)}</p></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="divide-y divide-white/10 lg:hidden">
              {filtered.map(lead => (
                <article key={lead.id} className="p-5">
                  <div className="flex items-start justify-between gap-4"><div><h2 className="font-semibold text-white">{lead.name}</h2><p className="mt-1 break-all text-xs text-zinc-500">{lead.email}</p></div><span className={`font-mono text-[9px] uppercase ${lead.expired ? 'text-rose-400' : 'text-cyan-300'}`}>{lead.expired ? 'expirada' : 'ativa'}</span></div>
                  <div className="mt-5 grid grid-cols-2 gap-4 text-xs"><div><span className="block text-zinc-700">Cadastro</span><span className="mt-1 block text-zinc-400">{formatDate(lead.createdAtMs)}</span></div><div><span className="block text-zinc-700">Restante</span><span className="mt-1 block text-zinc-400">{formatRemaining(lead.remainingMs)}</span></div><div><span className="block text-zinc-700">LGPD</span><span className="mt-1 block text-emerald-400">Registrado</span></div><div><span className="block text-zinc-700">E-mail</span><span className="mt-1 block uppercase text-zinc-400">{lead.emailStatus}</span></div></div>
                </article>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
}

export default function Admin() {
  return <DashboardLayout><AdminContent /></DashboardLayout>;
}
